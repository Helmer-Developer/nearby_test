part of '../protocol.dart';

///Data class to contain all information about a discoverd device
///
///[id] and [username] are required
///provides all necessary functions like converting to json and back to dart object
class DiscoverDevice {
  String id;
  String? username;
  ConnectionStatus? connectionStatus;
  DiscoverDevice({
    required this.id,
    this.username,
    this.connectionStatus,
  });

  ///Function to create new DiscoverdDevice while replacing some or no parameters
  DiscoverDevice copyWith({
    String? id,
    String? username,
    ConnectionStatus? connectionStatus = ConnectionStatus.connected,
  }) {
    return DiscoverDevice(
      id: id ?? this.id,
      username: username ?? this.username,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  ///converts [DiscoverDevice] to a JS Object-alike structure
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'connectionStatus': connectionStatus?.toString(),
    };
  }

  ///converts map (JS Object-alike structure) to a dart object
  factory DiscoverDevice.fromMap(Map<String, dynamic> map) {
    return DiscoverDevice(
      id: map['id'] as String,
      username: map['username'] as String,
      connectionStatus: map['connectionStatus'] != null
          ? ConnectionStatus.values.firstWhere(
              (status) => status.toString() == map['connectionStatus'],
            )
          : null,
    );
  }

  ///converts to json string
  String toJson() => json.encode(toMap());

  ///converts json string to dart object
  factory DiscoverDevice.fromJson(String source) =>
      DiscoverDevice.fromMap(json.decode(source) as Map<String, dynamic>);

  ///converts object to a readable string
  @override
  String toString() =>
      'DiscoverDevice(id: $id, username: $username, connectionStatus: $connectionStatus)';

  ///overrides equality operator (due to dart's strict equality)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DiscoverDevice && other.id == id;
  }

  ///overrides [hashCode] as dart's best practice suggests
  @override
  int get hashCode => id.hashCode ^ runtimeType.hashCode;
}
