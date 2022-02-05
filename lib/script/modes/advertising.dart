part of '../script.dart';

void advertising(Nearby nearby, WidgetRef ref, BuildContext context) {
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
