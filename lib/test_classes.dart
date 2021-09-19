class DiscoverDevice {
  String id;
  String username;
  ConnectionStatus? connectionStatus;
  DiscoverDevice({
    required this.id,
    required this.username,
    this.connectionStatus,
  });
}

enum ConnectionStatus { waitng, done, error }
