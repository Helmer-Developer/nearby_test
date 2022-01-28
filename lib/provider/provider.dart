/// Library which is responsible for all shared and changing data in the application.

library provider;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/protocol/protocol.dart';

part 'log.dart';
part 'me.dart';

final ChangeNotifierProvider<ConnectedDevicesGraph> graphProvider =
    ChangeNotifierProvider<ConnectedDevicesGraph>((ref) {
  final me = ref.read(meProvider);
  Nearby().stopAllEndpoints();
  return ConnectedDevicesGraph(me.ownId, me.ownName);
});

final ChangeNotifierProvider<Me> meProvider =
    ChangeNotifierProvider<Me>((ref) => Me());

final ChangeNotifierProvider<Log> logProvider =
    ChangeNotifierProvider<Log>((ref) => Log());
