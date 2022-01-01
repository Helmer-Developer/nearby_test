///The libary containing all information and classes about the Nearby Connections Protocol (NCP)

library protocol;

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:nearby_test/global/globals.dart';

part 'graph/connected_devices_graph.dart';
part 'graph/discoverd_device.dart';
part 'message/message.dart';
part 'message/message_interpreter.dart';
part 'message/message_type.dart';
part 'route_node.dart';


typedef MessageRoute = List<RouteNode>;
