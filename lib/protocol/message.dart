part of 'protocol.dart';

///Class to streamline all information between a device connection
///
///Shall be the only class which is exchanged via the NCA

class Message {
  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.route,
    required this.payload,
    required this.messageType,
  });

  ///Unique id to identfy message
  ///
  ///Should be generated by sender
  ///Because uniqueness is not always guaranteed, a time-based method is recommended
  ///Example:
  ///```dart
  ///Uuid().v4()
  ///```
  String id;

  ///Unique id to identfy the sender
  String senderId;

  ///Unique id to identfy the receiver
  String receiverId;

  ///List of [RouteNode] represending the rout chossen by the sender
  MessageRoute route;

  ///payload of the message
  ///
  ///shoulde be coresponding with the [messageType]
  dynamic payload;

  ///representing the type of the message
  ///
  ///shoulde be coresoinding with the [payload]
  MessageType messageType;
}