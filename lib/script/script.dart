library script;

import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/global/globals.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:nearby_test/provider/provider.dart';

final Communications communication = Communications(NcaService());

void advertise(Nearby nearby, WidgetRef ref) {
  final me = ref.read(meProvider);
  final log = ref.read(logProvider);
  log.addLog('Advertisment started');
  nearby.stopDiscovery();
  nearby.startAdvertising(
    me.ownName,
    strategy,
    onConnectionInitiated: (endpointId, connectionInfo) {
      log.addLog('onConnectionInitiated: $endpointId, info: $connectionInfo');
      ref.read(graphProvider).addDeviceWithMe(
            DiscoverDevice(
              id: endpointId,
              username: connectionInfo.endpointName,
              connectionStatus: ConnectionStatus.waitng,
            ),
          );
      nearby.acceptConnection(
        endpointId,
        onPayLoadRecieved: (endpointId, payload) {
          log.addLog(
            'onPayLoadRecieved: $endpointId, payload: ${String.fromCharCodes(payload.bytes!.toList())}',
          );
          communication.messageInput(
            Message.fromJson(String.fromCharCodes(payload.bytes!.toList())),
            ref.read(graphProvider),
          );
        },
      );
    },
    onConnectionResult: (endpointId, status) {
      log.addLog('onConnectionResult: $endpointId, status: $status');
      final oldDevice = ref
          .read(graphProvider)
          .graph
          .vertices
          .firstWhere((device) => device.id == endpointId);
      if (status == Status.CONNECTED) {
        ref.read(graphProvider).replaceDevice(
              DiscoverDevice(
                id: endpointId,
                username: oldDevice.username,
                connectionStatus: ConnectionStatus.connected,
              ),
            );
      } else if (status == Status.ERROR) {
        ref.read(graphProvider).replaceDevice(
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
      ref.read(graphProvider).removeDevice(
            DiscoverDevice(id: endpointId, username: endpointId),
          );
    },
    serviceId: 'com.example.nearby_test',
  );
}

void discover(Nearby nearby, WidgetRef ref) {
  final me = ref.read(meProvider);
  final log = ref.read(logProvider);
  log.addLog('Discoverment started');
  nearby.stopAdvertising();
  nearby.startDiscovery(
    me.ownName,
    strategy,
    onEndpointFound: (endpointId, name, serviceId) {
      log.addLog(
        'onEndpointFound: $endpointId, name: $name, serviceId: $serviceId, new: ${!ref.read(graphProvider).contains(
              DiscoverDevice(id: endpointId, username: name),
            )}',
      );
      if (ref.read(graphProvider).contains(
            DiscoverDevice(id: endpointId, username: endpointId),
          )) {
        log.addLog('$endpointId already in graph');
        return;
      }
      ref.read(graphProvider).addDeviceWithMe(
            DiscoverDevice(
              id: endpointId,
              username: name,
              connectionStatus: ConnectionStatus.waitng,
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
              log.addLog(
                'onPayLoadRecieved: $endpointId, payload: ${String.fromCharCodes(payload.bytes!.toList())}',
              );
              communication.messageInput(
                Message.fromJson(String.fromCharCodes(payload.bytes!.toList())),
                ref.read(graphProvider),
              );
            },
          );
        },
        onConnectionResult: (endpointId, status) {
          log.addLog('onConnectionResult: $endpointId, status: $status');
          final oldDevice = ref.read(graphProvider).getDeviceById(endpointId)!;
          if (status == Status.CONNECTED) {
            ref.read(graphProvider).replaceDevice(
                  DiscoverDevice(
                    id: endpointId,
                    username: oldDevice.username,
                    connectionStatus: ConnectionStatus.connected,
                  ),
                );
          } else if (status == Status.ERROR) {
            ref.read(graphProvider).replaceDevice(
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
          ref.read(graphProvider).removeDevice(
                DiscoverDevice(id: endpointId, username: endpointId),
              );
        },
      );
    },
    onEndpointLost: (endpointId) {
      log.addLog('onEndpointLost: $endpointId');
      if (endpointId != null) {
        if (ref
                .read(graphProvider)
                .getDeviceById(endpointId)!
                .connectionStatus ==
            ConnectionStatus.connected) return;
        ref.read(graphProvider).removeDevice(
              DiscoverDevice(id: endpointId, username: endpointId),
            );
      }
    },
    serviceId: 'com.example.nearby_test',
  );
}

Future<void> getneigbours(WidgetRef ref) async {
  while (true) {
    final graph = ref.read(graphProvider);
    final me = ref.read(meProvider);
    for (final node in graph.graph.vertices) {
      if (node.id != me.ownId) {
        final route = graph.getRoute(
          DiscoverDevice(id: me.ownId, username: me.ownName),
          DiscoverDevice(id: node.id, username: node.username),
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
