library ncp_service;

import 'dart:typed_data';

import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/protocol/protocol.dart';

part 'nca_service.dart';

abstract class NcpService {
  void sendMessageToId(Message message, String id);
}
