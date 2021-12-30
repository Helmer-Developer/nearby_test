///The libary containing all information and classes about the Nearby Connections Protocol (NCP)

library protocol;

import 'dart:convert';

part 'message.dart';
part 'route_node.dart';
part 'message_type.dart';


typedef MessageRoute = List<RouteNode>;