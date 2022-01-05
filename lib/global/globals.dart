///The libary globals
///
///The libary containing all globally shared information
///May be replaced with a inherited structure in the future (just like the provider package)

library globals;

import 'package:nearby_connections/nearby_connections.dart';

part 'difinitions.dart';

///The globally shared nickname
late String nickName;
Strategy strategy = Strategy.P2P_CLUSTER;
