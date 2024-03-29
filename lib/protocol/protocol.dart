///The library containing all information and classes about the Nearby Connections Protocol (NCP)

library protocol;

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:flutter/foundation.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/provider/provider.dart';
import 'package:uuid/uuid.dart';

part 'graph/connected_devices_graph.dart';
part 'graph/discoverd_device.dart';
part 'communication/communication.dart';
part 'message/message.dart';
part 'message/message_interpreter.dart';
part 'message/message_type.dart';
part 'message/route_node.dart';
part 'communication/ncp_service/ncp_service.dart';
part 'communication/ncp_service/nca_service.dart';
part 'communication/ncp_service/dummy_ncp_service.dart';

typedef MessageRoute = List<RouteNode>;
