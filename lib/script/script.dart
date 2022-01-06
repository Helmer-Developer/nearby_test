library script;

import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/global/globals.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:nearby_test/provider/provider.dart';

void advertise(Nearby nearby, WidgetRef ref) {
  final me = ref.read(meProvider);
  final graph = ref.read(graphProvider);
  final log = ref.read(logProvider);
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
          username: endpointId,
          connectionStatus: ConnectionStatus.waitng,
        ),
      );
      nearby.acceptConnection(
        endpointId,
        onPayLoadRecieved: (endpointId, payload) {
          log.addLog('onPayLoadRecieved: $endpointId, payload: $payload');
        },
      );
    },
    onConnectionResult: (endpointId, status) {
      log.addLog('onConnectionResult: $endpointId, status: $status');
      if (status == Status.CONNECTED) {
        graph.replaceDevice(
          DiscoverDevice(
            id: endpointId,
            username: endpointId,
            connectionStatus: ConnectionStatus.connected,
          ),
        );
      } else if (status == Status.ERROR) {
        graph.replaceDevice(
          DiscoverDevice(
            id: endpointId,
            username: endpointId,
            connectionStatus: ConnectionStatus.error,
          ),
        );
      }
    },
    onDisconnected: (endpointId) {
      log.addLog('onDisconnected: $endpointId');
      graph.removeDevice(
        DiscoverDevice(id: endpointId, username: endpointId),
      );
    },
    serviceId: 'com.example.nearby_test',
  );
}

void discover(Nearby nearby, WidgetRef ref) {
  final me = ref.read(meProvider);
  final graph = ref.read(graphProvider);
  final log = ref.read(logProvider);
  log.addLog('Discoverment started');
  nearby.stopAdvertising();
  nearby.startDiscovery(
    me.ownName,
    strategy,
    onEndpointFound: (endpointId, info, serviceId) {
      log.addLog(
        'onEndpointFound: $endpointId, info: $info, serviceId: $serviceId',
      );
      if (graph.contains(
        DiscoverDevice(id: endpointId, username: endpointId),
      )) {
        log.addLog('$endpointId already in graph');
        return;
      }
      graph.addDeviceWithMe(
        DiscoverDevice(
          id: endpointId,
          username: info,
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
                'onPayLoadRecieved: $endpointId, payload: $payload',
              );
            },
          );
        },
        onConnectionResult: (endpointId, status) {
          log.addLog('onConnectionResult: $endpointId, status: $status');
          if (status == Status.CONNECTED) {
            graph.replaceDevice(
              DiscoverDevice(
                id: endpointId,
                username: endpointId,
                connectionStatus: ConnectionStatus.connected,
              ),
            );
          } else if (status == Status.ERROR) {
            graph.replaceDevice(
              DiscoverDevice(
                id: endpointId,
                username: endpointId,
                connectionStatus: ConnectionStatus.error,
              ),
            );
          }
        },
        onDisconnected: (endpointId) {
          log.addLog('onDisconnected: $endpointId');
          graph.removeDevice(
            DiscoverDevice(id: endpointId, username: endpointId),
          );
        },
      );
    },
    onEndpointLost: (endpointId) {
      log.addLog('onEndpointLost: $endpointId');
      if (endpointId != null) {
        graph.removeDevice(
          DiscoverDevice(id: endpointId, username: endpointId),
        );
      }
    },
    serviceId: 'com.example.nearby_test',
  );
}
