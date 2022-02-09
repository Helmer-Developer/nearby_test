part of '../script.dart';

Future<void> _onConnectionInitiated(
  String endpointId,
  ConnectionInfo connectionInfo,
  WidgetRef ref,
  BuildContext context,
) async {
  final me = ref.read(meProvider);
  final log = ref.read(logProvider);
  final graph = ref.read(graphProvider);
  final Nearby nearby = Nearby();
  log.addLog(
    'Device $endpointId wants to start handshake (details: $connectionInfo)',
  );
  if (graph.containsById(endpointId)) {
    log.addLog('Error: Device $endpointId is already in the graph');
    return;
  }
  final userResponse =
      await ConnectionDialogs.acceptConnection(endpointId, context);
  if (userResponse == null || (!userResponse)) return;
  graph.addDeviceWithMe(
    DiscoveredDevice(
      id: endpointId,
      username: connectionInfo.endpointName,
      connectionStatus: ConnectionStatus.waiting,
    ),
  );
  log.addLog(
    'Adding Device $endpointId to graph with connections status: waiting',
  );
  nearby.acceptConnection(
    endpointId,
    onPayLoadRecieved: (endpointId, payload) {
      final decodedPayload = String.fromCharCodes(payload.bytes!.toList());
      log.addLog(
        'Received payload $decodedPayload from Device: $endpointId.',
      );
      if (decodedPayload == 'idRequest') {
        nearby.sendBytesPayload(
          endpointId,
          Uint8List.fromList(endpointId.codeUnits),
        );
        log.addLog(
          'Got ID request form Device: $endpointId, responding with $endpointId.',
        );
      } else if (!decodedPayload.startsWith('{')) {
        me.ownId = decodedPayload;
        log.addLog(
          'Got ID response form $endpointId. Overriding own ID with $decodedPayload.',
        );
      } else {
        final maybeTextForMe = communication.messageInput(
          message: Message.fromJson(decodedPayload),
          graph: graph,
          me: me,
        );
        if (maybeTextForMe != null) {
          Fluttertoast.showToast(msg: maybeTextForMe);
        }
        log.addLog(
          'Commit the message form $endpointId to the protocol library.',
        );
      }
    },
  );
  log.addLog('Trying to fulfill handshake with Device $endpointId');
}
