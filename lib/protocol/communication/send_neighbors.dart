part of 'communication.dart';

void comSendNeighborsToId({
  required String receiverId,
  required String senderId,
  required List<DiscoverDevice> devices,
  required MessageRoute route,
}) {
  final List<Map> data = devices.map((device) => device.toMap()).toList();
  final Message message = Message(
    id: const Uuid().v4(),
    senderId: senderId,
    receiverId: receiverId,
    route: route,
    payload: data,
    messageType: MessageType.neighborsResponse,
  );
}
