/// Library which defines the steps a device performs during being part of a network in a scripted manner.

library script;

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
  log.addLog('Advertisment started');
  nearby.stopDiscovery();
  nearby.startAdvertising(
    me.ownName,
    strategy,
    onConnectionInitiated: (endpointId, connectionInfo) {
      log.addLog('onConnectionInitiated: $endpointId, info: $connectionInfo');
      graph.addDeviceWithMe(
        DiscoverDevice(
          id: endpointId,
          username: connectionInfo.endpointName,
          connectionStatus: ConnectionStatus.waiting,
        ),
      );
      nearby.acceptConnection(
        endpointId,
        onPayLoadRecieved: (endpointId, payload) {
          final decodedPayload = String.fromCharCodes(payload.bytes!.toList());
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
      final oldDevice = graph.getDeviceById(endpointId);
      if (status == Status.CONNECTED) {
        graph.replaceDevice(
          DiscoverDevice(
            id: endpointId,
            username: oldDevice?.username,
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
            username: oldDevice?.username,
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
