import 'package:nearby_test/global/difinitions.dart';

class DiscoverDevice {
  String id;
  String username;
  ConnectionStatus? connectionStatus;
  DiscoverDevice({
    required this.id,
    required this.username,
    this.connectionStatus,
  });

  String get toJson => '';
}
