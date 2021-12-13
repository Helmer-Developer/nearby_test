library communication;

import 'dart:typed_data';

import 'package:nearby_test/global/globals.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:uuid/uuid.dart';

part 'send_neighbors.dart';
part 'dummy_route.dart';
part 'handle_message.dart';

class Communications {
  static Function sendNeighborsToId = comSendNeighborsToId;

  static sendMessageToId(Message message, String id) {
    const String data = 'dummy message'; //TODO: Add to Json implementation
    Nearby().sendBytesPayload(id, Uint8List.fromList(data.codeUnits));
  }
}
