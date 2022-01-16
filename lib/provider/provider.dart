/// Library which is responsible for all shared and changing data in the application.

library provider;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_test/protocol/protocol.dart';

part 'log.dart';
part 'me.dart';

final graphProvider = ChangeNotifierProvider<ConnectedDevicesGraph>((ref) {
  final me = ref.watch(meProvider);
  return ConnectedDevicesGraph(me.ownId, me.ownName);
});

final meProvider = ChangeNotifierProvider<Me>((ref) => Me());

final logProvider = ChangeNotifierProvider<Log>((ref) => Log());
