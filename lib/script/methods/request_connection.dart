part of '../script.dart';

void requestConnection(
  Nearby nearby,
  String endpointId,
  WidgetRef ref,
  BuildContext context,
) {
  final me = ref.read(meProvider);
  nearby.requestConnection(
    me.ownName,
    endpointId,
    onConnectionInitiated: (endpointId, connectionInfo) =>
        onConnectionInitiated(endpointId, connectionInfo, ref, context),
    onConnectionResult: (endpointId, status) =>
        onConnectionResult(endpointId, status, ref),
    onDisconnected: (endpointId) => onDisconnected(endpointId, ref),
  );
}