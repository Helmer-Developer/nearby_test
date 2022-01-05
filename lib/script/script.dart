library script;

import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/global/globals.dart';
import 'package:nearby_test/provider/provider.dart';

void advertisment(Nearby nearby, WidgetRef ref) {
  final me = ref.read(meProvider);
  final log = ref.read(logProvider);
  log.addLog('Advertisment started');
  nearby.stopDiscovery();
  nearby.startAdvertising(
    me.ownName,
    strategy,
    onConnectionInitiated: (endpointId, connectionInfo) {
      log.addLog('onConnectionInitiated: $endpointId, info: $connectionInfo');
      nearby.acceptConnection(
        endpointId,
        onPayLoadRecieved: (endpointId, payload) {
          log.addLog('onPayLoadRecieved: $endpointId, payload: $payload');
        },
      );
    },
    onConnectionResult: (endpointId, status) {
      log.addLog('onConnectionResult: $endpointId, status: $status');
    },
    onDisconnected: (endpointId) {
      log.addLog('onDisconnected: $endpointId');
    },
    serviceId: 'com.example.nearby_test',
  );
}

void discoverment(Nearby nearby, WidgetRef ref) {
  final me = ref.read(meProvider);
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
        },
        onDisconnected: (endpointId) {
          log.addLog('onDisconnected: $endpointId');
        },
      );
    },
    onEndpointLost: (endpointId) {
      log.addLog('onEndpointLost: $endpointId');
    },
    serviceId: 'com.example.nearby_test',
  );
}
