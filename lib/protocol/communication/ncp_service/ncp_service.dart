part of '../../protocol.dart';

///Absract class defining all necessary methods for a NCP service
///
///This class is used to define the methods that a NCP service must implement
///Curretnly only the method for sending data is required
abstract class NcpService {
  Future<void> sendMessageToId(Message message, String id);
}
