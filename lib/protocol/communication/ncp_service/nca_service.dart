part of 'ncp_service.dart';

class NcaService with NcpService {
  @override
  void sendMessageToId(Message message, String id) {
    final String data = message.toJson();
    Nearby().sendBytesPayload(id, Uint8List.fromList(data.codeUnits));
  }
}
