import 'package:nearby_test/protocol/protocol.dart';

class DummyNcpService with NcpService {
  @override
  Future<void> sendMessageToId(Message message, String id) async {
    print(
      'Would send:\nMessage: $message\nTo: $id',
    );
  }
}
