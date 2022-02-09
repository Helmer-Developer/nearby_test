/// Library which defines the steps a device performs during being part of a network in a scripted manner.

library script;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:nearby_test/provider/provider.dart';
import 'package:nearby_test/ui/ui.dart';

part 'modes/advertising.dart';
part 'modes/discovery.dart';
part 'methods/request_connection.dart';
part 'methods/on_connection_initiated.dart';
part 'methods/on_connection_result.dart';
part 'methods/on_disconnected.dart';

final Communications communication = Communications(NcaService());
const Strategy strategy = Strategy.P2P_CLUSTER;

Future<void> getNeighbors(WidgetRef ref) async {
  while (true) {
    final graph = ref.read(graphProvider);
    final me = ref.read(meProvider);
    for (final node in graph.graph.vertices) {
      if (node.id != me.ownId &&
          node.connectionStatus == ConnectionStatus.connected) {
        final route = graph.getRoute(
          DiscoveredDevice(id: me.ownId),
          DiscoveredDevice(id: node.id),
        );
        if (route != null) {
          communication.requestNeighbors(
            receiverId: node.id,
            ownId: me.ownId,
            route: route,
          );
        }
      }
    }
    await Future.delayed(const Duration(seconds: 5));
  }
}
