///library for the NCP service to abstract the service (useful for testing)
library ncp_service;

import 'dart:typed_data';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/protocol/protocol.dart';

part 'nca_service.dart';

///Absract class defining all necessary methods for a NCP service
///
///This class is used to define the methods that a NCP service must implement
///Curretnly only the method for sending data is required
abstract class NcpService {
  Future<void> sendMessageToId(Message message, String id);
}
