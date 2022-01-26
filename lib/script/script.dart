/// Library which defines the steps a device performs during being part of a network in a scripted manner.

library script;

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:nearby_test/provider/provider.dart';

final Communications communication = Communications(NcaService());
const Strategy strategy = Strategy.P2P_CLUSTER;

void advertise(Nearby nearby, WidgetRef ref) {
  final me = ref.read(meProvider);
  final log = ref.read(logProvider);
  final graph = ref.read(graphProvider);
  log.addLog('Advertising started due to function call');
  nearby.stopDiscovery();
  nearby.startAdvertising(
    me.ownName,
    strategy,
    onConnectionInitiated: (endpointId, connectionInfo) {
      log.addLog(
        'Device $endpointId wants to start handshake (details: $connectionInfo)',
      );
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
          if (decodedPayload == 'idrequest') {
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
            communication.messageInput(
              message: Message.fromJson(decodedPayload),
              graph: graph,
              me: me,
            );
            log.addLog(
              'Commit the message form $endpointId to the protocol library.',
            );
          }
        },
      );
      log.addLog('Trying to fulfill handshake with Device $endpointId');
    },
    onConnectionResult: (endpointId, status) {
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
          if (me.ownId == 'me') {
            nearby.sendBytesPayload(
              endpointId,
              Uint8List.fromList('idrequest'.codeUnits),
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
        } else {
          log.addLog('Error: Device does not exist in graph');
        }
      }
    },
    onDisconnected: (endpointId) {
      log.addLog('Device: $endpointId disconnected');
      graph.removeDevice(
        DiscoverDevice(id: endpointId),
      );
    },
    serviceId: 'com.example.nearby_test',
  );
}

void discover(Nearby nearby, WidgetRef ref) {
  final me = ref.read(meProvider);
  final log = ref.read(logProvider);
  final graph = ref.read(graphProvider);
  log.addLog('Discoverment started');
  nearby.stopAdvertising();
  nearby.startDiscovery(
    me.ownName,
    strategy,
    onEndpointFound: (endpointId, name, serviceId) {
      log.addLog(
        'onEndpointFound: $endpointId, name: $name, serviceId: $serviceId, new: ${!graph.contains(
          DiscoverDevice(id: endpointId, username: name),
        )}',
      );
      if (graph.contains(
        DiscoverDevice(id: endpointId),
      )) {
        log.addLog('$endpointId already in graph');
        return;
      }
      graph.addDeviceWithMe(
        DiscoverDevice(
          id: endpointId,
          username: name,
          connectionStatus: ConnectionStatus.waiting,
        ),
      );
      nearby.requestConnection(
        me.ownName,
        endpointId,
        onConnectionInitiated: (endpointId, connectionInfo) {
          log.addLog(
            'onConnectionInitiated: $endpointId, info: $connectionInfo',
          );
          nearby.acceptConnection(
            endpointId,
            onPayLoadRecieved: (endpointId, payload) {
              final decodedPayload =
                  String.fromCharCodes(payload.bytes!.toList());
              log.addLog(
                'onPayLoadRecieved: $endpointId, payload: $decodedPayload',
              );
              if (decodedPayload == 'idrequest') {
                nearby.sendBytesPayload(
                  endpointId,
                  Uint8List.fromList(endpointId.codeUnits),
                );
              } else if (!decodedPayload.startsWith('{')) {
                me.ownId = decodedPayload;
              } else {
                communication.messageInput(
                  message: Message.fromJson(decodedPayload),
                  graph: graph,
                  me: me,
                );
              }
            },
          );
        },
        onConnectionResult: (endpointId, status) {
          log.addLog('onConnectionResult: $endpointId, status: $status');
          final oldDevice = graph.getDeviceById(endpointId)!;
          if (status == Status.CONNECTED) {
            graph.replaceDevice(
              DiscoverDevice(
                id: endpointId,
                username: oldDevice.username,
                connectionStatus: ConnectionStatus.connected,
              ),
            );
            if (me.ownId == 'me') {
              nearby.sendBytesPayload(
                endpointId,
                Uint8List.fromList('idrequest'.codeUnits),
              );
            }
          } else if (status == Status.ERROR) {
            graph.replaceDevice(
              DiscoverDevice(
                id: endpointId,
                username: oldDevice.username,
                connectionStatus: ConnectionStatus.error,
              ),
            );
          }
        },
        onDisconnected: (endpointId) {
          log.addLog('onDisconnected: $endpointId');
          graph.removeDevice(
            DiscoverDevice(id: endpointId),
          );
        },
      ).then((value) => log.addLog('request connection returned: $value'));
    },
    onEndpointLost: (endpointId) {
      log.addLog('onEndpointLost: $endpointId');
      if (endpointId != null) {
        if (graph.getDeviceById(endpointId)!.connectionStatus ==
            ConnectionStatus.connected) return;
        graph.removeDevice(
          DiscoverDevice(id: endpointId),
        );
      }
    },
    serviceId: 'com.example.nearby_test',
  );
}
