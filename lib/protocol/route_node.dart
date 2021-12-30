part of 'protocol.dart';

/// Class to abscarct all infomation about a node in a message route
///
/// [isSender] and [isReceiver] can't be true at the same time.
class RouteNode {
  RouteNode({
    required this.deviceId,
    required this.isSender,
    required this.isReceiver,
  }) : assert(
          (isSender && isReceiver) == false,
          'isSender and isReciver can not be true at the same time',
        );

  /// Id to identify the device
  String deviceId;

  /// Boolean value wether [RouteNode] is sender or not
  bool isSender;

  /// Boolean value wether [RouteNode] is receiver or not
  bool isReceiver;

  /// Convert [RouteNode] to [Map]
  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'isSender': isSender,
      'isReceiver': isReceiver,
    };
  }

  /// Convert [Map] to [RouteNode]
  static RouteNode fromMap(Map<String, dynamic> map) {
    return RouteNode(
      deviceId: map['deviceId'],
      isSender: map['isSender'],
      isReceiver: map['isReceiver'],
    );
  }

  /// Override toString method
  @override
  String toString() {
    return 'RouteNode{deviceId: $deviceId, isSender: $isSender, isReceiver: $isReceiver}';
  }

  /// Override hashCode
  @override
  int get hashCode =>
      deviceId.hashCode ^ isSender.hashCode ^ isReceiver.hashCode;

  /// Override == operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteNode &&
          runtimeType == other.runtimeType &&
          deviceId == other.deviceId &&
          isSender == other.isSender &&
          isReceiver == other.isReceiver;
}
