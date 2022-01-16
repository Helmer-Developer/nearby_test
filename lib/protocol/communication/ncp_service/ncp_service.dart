part of '../../protocol.dart';

///Abstract class defining all necessary methods for a NCP service
///
///This class is used to define the methods that a NCP service must implement
///Currently only the method for sending data is required
abstract class NcpService {

  /// Sends the given [message] to the given [id]
  Future<void> sendMessageToId(Message message, String id);
}
