/// Library which defines the steps a device performs during being part of a network in a scripted manner.

library script;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:nearby_test/provider/provider.dart';
import 'package:nearby_test/ui/ui.dart';

final Communications communication = Communications(NcaService());
const Strategy strategy = Strategy.P2P_CLUSTER;

void advertise(Nearby nearby, WidgetRef ref, BuildContext context) {
  final me = ref.read(meProvider);
  final log = ref.read(logProvider);
  log.addLog('Advertising started due to function call');
  nearby.stopDiscovery();
  nearby.startAdvertising(
    me.ownName,
    strategy,
    onConnectionInitiated: (endpointId, connectionInfo) =>
        onConnectionInitiated(endpointId, connectionInfo, ref, context),
    onConnectionResult: (endpointId, status) =>
        onConnectionResult(endpointId, status, ref),
    onDisconnected: (endpointId) => onDisconnected(endpointId, ref),
    serviceId: 'com.example.nearby_test',
  );
}

void discover(Nearby nearby, WidgetRef ref, BuildContext context) {
  final me = ref.read(meProvider);
  final log = ref.read(logProvider);
  final graph = ref.read(graphProvider);
  log.addLog('Discovering started due to function call');
  nearby.stopAdvertising();
  nearby.startDiscovery(
    me.ownName,
    strategy,
    onEndpointFound: (endpointId, name, serviceId) async {
      log.addLog('Device found: $endpointId');
      if (graph.containsById(endpointId)) {
        if (graph.isConnectedToMeById(endpointId)) {
          log.addLog('Device is already connected to me');
          return;
        } else {
          log.addLog(
            'Device is not connected to me asking user if he wants to connect directly',
          );
          final userWantsToConnect =
              await ConnectionDialogs.connectWithAlreadyExistingDevice(
            endpointId,
            context,
          );
          if (userWantsToConnect != null && userWantsToConnect) {
            log.addLog('User wants to connect directly');
            nearby.requestConnection(
              me.ownName,
              endpointId,
              onConnectionInitiated: (endpointId, connectionInfo) =>
                  onConnectionInitiated(
                endpointId,
                connectionInfo,
                ref,
                context,
              ),
              onConnectionResult: (endpointId, status) =>
                  onConnectionResult(endpointId, status, ref),
              onDisconnected: (endpointId) => onDisconnected(endpointId, ref),
            );
          }
        }
      }
      nearby.requestConnection(
        me.ownName,
        endpointId,
        onConnectionInitiated: (endpointId, connectionInfo) =>
            onConnectionInitiated(endpointId, connectionInfo, ref, context),
        onConnectionResult: (endpointId, status) =>
            onConnectionResult(endpointId, status, ref),
        onDisconnected: (endpointId) => onDisconnected(endpointId, ref),
      );
    },
    onEndpointLost: (endpointId) {
      log.addLog('Endpoint lost: $endpointId');
    },
    serviceId: 'com.example.nearby_test',
  );
}

Future<void> onConnectionInitiated(
  String endpointId,
  ConnectionInfo connectionInfo,
  WidgetRef ref,
  BuildContext context,
) async {
  final me = ref.read(meProvider);
  final log = ref.read(logProvider);
  final graph = ref.read(graphProvider);
  final Nearby nearby = Nearby();
  log.addLog(
    'Device $endpointId wants to start handshake (details: $connectionInfo)',
  );
  if (graph.containsById(endpointId)) {
    log.addLog('Error: Device $endpointId is already in the graph');
    return;
  }
  final userResponse =
      await ConnectionDialogs.acceptConnection(endpointId, context);
  if (userResponse == null || (!userResponse)) return;
  graph.addDeviceWithMe(
    DiscoverDevice(
      id: endpointId,
      username: connectionInfo.endpointName,
      connectionStatus: ConnectionStatus.waiting,
    ),
  );
  log.addLog(
    'Adding Device $endpointId to graph with connections status: waiting',
  );
  nearby.acceptConnection(
    endpointId,
    onPayLoadRecieved: (endpointId, payload) {
      final decodedPayload = String.fromCharCodes(payload.bytes!.toList());
      log.addLog(
        'Received payload $decodedPayload from Device: $endpointId.',
      );
      if (decodedPayload == 'idRequest') {
        nearby.sendBytesPayload(
          endpointId,
          Uint8List.fromList(endpointId.codeUnits),
        );
        log.addLog(
          'Got ID request form Device: $endpointId, responding with $endpointId.',
        );
      } else if (!decodedPayload.startsWith('{')) {
        me.ownId = decodedPayload;
        log.addLog(
          'Got ID response form $endpointId. Overriding own ID with $decodedPayload.',
        );
      } else {
        final maybeTextForMe = communication.messageInput(
          message: Message.fromJson(decodedPayload),
          graph: graph,
          me: me,
        );
        if (maybeTextForMe != null) {
          Fluttertoast.showToast(msg: maybeTextForMe);
        }
        log.addLog(
          'Commit the message form $endpointId to the protocol library.',
        );
      }
    },
  );
  log.addLog('Trying to fulfill handshake with Device $endpointId');
}

void onConnectionResult(String endpointId, Status status, WidgetRef ref) {
  final me = ref.read(meProvider);
  final log = ref.read(logProvider);
  final graph = ref.read(graphProvider);
  final Nearby nearby = Nearby();
  log.addLog(
    'Handshake with Device: $endpointId fulfilled with status: ${status.name}',
  );
  final oldDevice = graph.getDeviceById(endpointId);
  if (graph.containsById(endpointId)) {
    if (status == Status.CONNECTED) {
      log.addLog('Handshake with Device: $endpointId succeeded');
      graph.replaceDevice(
        DiscoverDevice(
          id: endpointId,
          username: oldDevice?.username,
          connectionStatus: ConnectionStatus.connected,
        ),
      );
      log.addLog(
        'Replace connection status of Device: $endpointId with connected.',
      );
      if (me.ownId == 'me' || me.ownId == 'unknown') {
        nearby.sendBytesPayload(
          endpointId,
          Uint8List.fromList('idRequest'.codeUnits),
        );
        log.addLog(
          'Send ID request to Device: $endpointId, because own ID is unknown',
        );
      }
    } else if (status == Status.ERROR || status == Status.REJECTED) {
      log.addLog('Handshake with Device: $endpointId failed');
      graph.replaceDevice(
        DiscoverDevice(
          id: endpointId,
          username: oldDevice?.username,
          connectionStatus: ConnectionStatus.error,
        ),
      );
      log.addLog(
        'Replace connection status of Device: $endpointId with error.',
      );
    }
  } else {
    log.addLog('Error: Device does not exist in graph');
  }
}

void onDisconnected(String endpointId, WidgetRef ref) {
  final log = ref.read(logProvider);
  final graph = ref.read(graphProvider);
  log.addLog('Device: $endpointId disconnected');
  if (!graph.containsById(endpointId)) {
    log.addLog('Error: Device: $endpointId does not exist in graph');
    return;
  }
  graph.removeDevice(
    DiscoverDevice(id: endpointId),
  );
  log.addLog(
    'Remove Device: $endpointId from graph, because it disconnected',
  );
}

Future<void> getNeighbors(WidgetRef ref) async {
  while (true) {
    final graph = ref.read(graphProvider);
    final me = ref.read(meProvider);
    for (final node in graph.graph.vertices) {
      if (node.id != me.ownId &&
          node.connectionStatus == ConnectionStatus.connected) {
        final route = graph.getRoute(
          DiscoverDevice(id: me.ownId),
          DiscoverDevice(id: node.id),
        );
        if (route != null) {
          communication.requestNeighbors(
            receiverId: node.id,
            ownId: me.ownId,
            route: route,
          );
        }
      }
    }
    await Future.delayed(const Duration(seconds: 5));
  }
}
