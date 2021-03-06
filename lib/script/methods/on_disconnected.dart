part of '../script.dart';

void _onDisconnected(String endpointId, WidgetRef ref) {
  final log = ref.read(logProvider);
  final graph = ref.read(graphProvider);
  log.addLog('Device: $endpointId disconnected');
  if (!graph.containsById(endpointId)) {
    log.addLog('Error: Device: $endpointId does not exist in graph');
    return;
  }
  graph.removeDevice(
    DiscoveredDevice(id: endpointId),
  );
  log.addLog(
    'Remove Device: $endpointId from graph, because it disconnected',
  );
}
