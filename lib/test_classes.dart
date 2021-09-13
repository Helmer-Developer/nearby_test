class DiscoverDevice {
  String id;
  String username;
  MyConnectionStatus? connectionStatus;
  DiscoverDevice({
    required this.id,
    required this.username,
    this.connectionStatus,
  });
}

enum MyConnectionStatus { waitng, done, error }
