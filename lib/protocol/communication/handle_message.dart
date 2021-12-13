part of 'communication.dart';

///Handles and incomming message
///
///Needs [ownId] to put message in context to device
///Retruns the Messsge if device is last node in messageroute
Message? comHandleMessage(Message message, String ownId) {
  if (message.receiverId == ownId) {
    return message;
  }
  final MessageRoute messageRoute = message.route;
  final messageRouteItorator = messageRoute.iterator;
}
