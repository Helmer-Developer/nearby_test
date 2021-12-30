import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_test/protocol/protocol.dart';

void main() {
  group('Message class test', () {
    test('To and form json test', () {
      final message = Message(
        id: 'test',
        senderId: '1',
        receiverId: '2',
        route: [
          RouteNode(deviceId: '1', isSender: true, isReceiver: false),
          RouteNode(deviceId: '2', isSender: false, isReceiver: true),
        ],
        payload: 'test payload',
        messageType: MessageType.text,
      );
      final jsonMessage = message.toJson();
      final newMessage = Message.fromJson(jsonMessage);
      expect(
        message,
        newMessage,
        reason:
            'message and newMessage should be equal due to equality operator override',
      );
    });
    test('hashCode and toString test', () {
      final message1 = Message(
        id: 'test',
        senderId: '1',
        receiverId: '2',
        route: [
          RouteNode(deviceId: '1', isSender: true, isReceiver: false),
          RouteNode(deviceId: '2', isSender: false, isReceiver: true),
        ],
        payload: 'test payload',
        messageType: MessageType.text,
      );
      final message2 = Message(
        id: 'test',
        senderId: '1',
        receiverId: '2',
        route: [
          RouteNode(deviceId: '1', isSender: true, isReceiver: false),
          RouteNode(deviceId: '2', isSender: false, isReceiver: true),
        ],
        payload: 'test payload',
        messageType: MessageType.text,
      );
      expect(
        message1.hashCode,
        message2.hashCode,
        reason: 'hashCode should be equal',
      );
      expect(
        message1.toString(),
        message2.toString(),
        reason: 'toString should be equal',
      );
    });
  });
}
