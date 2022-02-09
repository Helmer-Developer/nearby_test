part of '../script.dart';

void _onConnectionResult(String endpointId, Status status, WidgetRef ref) {
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
        DiscoveredDevice(
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
        DiscoveredDevice(
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
