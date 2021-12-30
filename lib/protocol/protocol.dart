///The libary containing all information and classes about the Nearby Connections Protocol (NCP)

library protocol;

import 'dart:convert';

import 'package:directed_graph/directed_graph.dart';
import 'package:nearby_test/global/globals.dart';
import 'package:collection/collection.dart';

part 'message.dart';
part 'route_node.dart';
part 'message_type.dart';
part 'graph/connected_devices_graph.dart';
part 'graph/discoverd_device.dart';


typedef MessageRoute = List<RouteNode>;