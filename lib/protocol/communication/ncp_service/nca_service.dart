part of '../../protocol.dart';

/// The NCA service implementation
///
/// This class is used to implement the NCA service for the NCP (real devices)
class NcaService with NcpService {
  @override
  Future<void> sendMessageToId(Message message, String id) async {
    final String data = message.toJson();
    await Nearby().sendBytesPayload(id, Uint8List.fromList(data.codeUnits));
  }
}
