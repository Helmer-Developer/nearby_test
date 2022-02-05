part of '../script.dart';

void _requestConnection(
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
        _onConnectionInitiated(endpointId, connectionInfo, ref, context),
    onConnectionResult: (endpointId, status) =>
        _onConnectionResult(endpointId, status, ref),
    onDisconnected: (endpointId) => _onDisconnected(endpointId, ref),
  );
}
