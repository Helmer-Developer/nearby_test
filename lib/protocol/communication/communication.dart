library communication;

import 'package:nearby_test/global/globals.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:uuid/uuid.dart';

part 'send_neighbors.dart';
part 'dummy_route.dart';

class Communications {
  static Function sendNeighborsToId = comSendNeighborsToId;
}
