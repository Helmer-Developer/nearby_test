part of '../../protocol.dart';

/// Dummy implementation of [NcpService].
/// 
/// For testing and environments where the NcaService is not available.
class DummyNcpService with NcpService {
  @override
  Future<void> sendMessageToId(Message message, String id) async {
    print(
      'Would send:\nMessage: $message\nTo: $id',
    );
  }
}
