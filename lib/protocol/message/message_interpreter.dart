part of '../protocol.dart';

/// Extension to interpret a [Message]
///
/// Use this Extension to interpret messages from [handleMessage] function.
extension MessageInterpreter on Message {
  /// Interpret the [message]
  ///
  /// returns a dynamic value due different message interpretation.
  dynamic interpret() {
    final message = this;
    switch (message.messageType) {
      case MessageType.text:
        if (message.payload is String) {
          return message.payload as String;
        } else {
          throw Exception(
            'Message payload is not a String as messageType suggests',
          );
        }
      case MessageType.neighborsRequest:
        if (message.payload == null) {
          return;
        } else {
          throw Exception(
            'Message payload is not null as messageType suggests',
          );
        }
      case MessageType.neighborsResponse:
        if (message.payload is List<Map>) {
          final jsonDevices = message.payload as List<Map<String, dynamic>>;
          final devices = jsonDevices
              .map((jsonDevice) => DiscoverDevice.fromMap(jsonDevice))
              .toList();
          return devices;
        } else {
          throw Exception(
            'Message payload is not a List<Map> as messageType suggests',
          );
        }
    }
  }
}
