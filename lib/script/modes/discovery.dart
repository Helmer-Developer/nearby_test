part of '../script.dart';

void discovery(Nearby nearby, WidgetRef ref, BuildContext context) {
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
            _requestConnection(nearby, endpointId, ref, context);
          }
        }
      }
     _requestConnection(nearby, endpointId, ref, context);
    },
    onEndpointLost: (endpointId) {
      log.addLog('Endpoint lost: $endpointId');
    },
    serviceId: 'com.example.nearby_test',
  );
}
