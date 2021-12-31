import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_test/global/globals.dart';
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
        payload: [
          DiscoverDevice(
            id: 'test',
            username: 'test',
            connectionStatus: ConnectionStatus.connected,
          ),
        ].map((e) => e.toMap()).toList(),
        messageType: MessageType.neighborsResponse,
      );
      final jsonMessage = message.toJson();
      final newMessage = Message.fromJson(jsonMessage);
      expect(
        message.hashCode,
        isNot(newMessage.hashCode),
        reason: 'hashCode should be different',
      );
      expect(
        message.toString(),
        newMessage.toString(),
        reason: 'message and newMessage string representation should be equal',
      );
    });
    //equality test
    test('Equality test', () {
      final message = Message(
        id: 'test',
        senderId: '1',
        receiverId: '2',
        route: [
          RouteNode(deviceId: '1', isSender: true, isReceiver: false),
          RouteNode(deviceId: '2', isSender: false, isReceiver: true),
        ],
        payload: 'test',
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
        payload: 'test',
        messageType: MessageType.text,
      );
      expect(
        message,
        message2,
        reason: 'message and message2 should be equal due to equality override',
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
