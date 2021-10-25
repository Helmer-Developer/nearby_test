import 'dart:convert';

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

  DiscoverDevice copyWith({
    String? id,
    String? username,
    ConnectionStatus? connectionStatus,
  }) {
    return DiscoverDevice(
      id: id ?? this.id,
      username: username ?? this.username,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'connectionStatus': connectionStatus?.toString(),
    };
  }

  factory DiscoverDevice.fromMap(Map<String, dynamic> map) {
    return DiscoverDevice(
      id: map['id'],
      username: map['username'],
      connectionStatus: map['connectionStatus'] != null
          ? ConnectionStatus.values.firstWhere(
              (status) => status.toString() == map['connectionStatus'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscoverDevice.fromJson(String source) =>
      DiscoverDevice.fromMap(json.decode(source));

  @override
  String toString() =>
      'DiscoverDevice(id: $id, username: $username, connectionStatus: $connectionStatus)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DiscoverDevice &&
        other.id == id &&
        other.username == username &&
        other.connectionStatus == connectionStatus;
  }

  @override
  int get hashCode =>
      id.hashCode ^ username.hashCode ^ connectionStatus.hashCode;
}
