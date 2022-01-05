library provider;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_test/protocol/protocol.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart';

part 'log.dart';
part 'me.dart';

final graphProvider = Provider<ConnectedDevicesGraph>((ref) {
  return ConnectedDevicesGraph(ref.watch(meProvider)._ownId);
});

final meProvider = ChangeNotifierProvider<Me>((ref) => Me());

final logProvider = ChangeNotifierProvider<Log>((ref) => Log());
