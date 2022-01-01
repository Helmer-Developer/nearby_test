import 'package:nearby_test/protocol/communication/ncp_service/ncp_service.dart';
import 'package:nearby_test/protocol/protocol.dart';

class DummyNcpService with NcpService {
  @override
  void sendMessageToId(Message message, String id) {
    print('''
    Would send:
    Message: $message
    To: $id
    ''',);
  }
}
