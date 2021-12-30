part of 'ncp_service.dart';

/// The NCA service impelementation
/// 
/// This class is used to implement the NCA service for the NCP (real devices)
class NcaService with NcpService {
  @override
  void sendMessageToId(Message message, String id) {
    final String data = message.toJson();
    Nearby().sendBytesPayload(id, Uint8List.fromList(data.codeUnits));
  }
}
