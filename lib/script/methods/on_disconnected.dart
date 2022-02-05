part of '../script.dart';

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