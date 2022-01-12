import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:uuid/uuid.dart';

import 'dummy_ncp_service.dart';

void main() {
  group('Communication library test ', () {
    final Communications communications = Communications(DummyNcpService());
    final message = Message(
      id: const Uuid().v4(),
      senderId: '1',
      receiverId: '2',
      route: [
        RouteNode(deviceId: '1', isSender: true, isReceiver: false),
        RouteNode(deviceId: '2', isSender: false, isReceiver: true),
      ],
      payload: 'test',
      messageType: MessageType.text,
    );
    test('basic send message test', () {
      try {
        communications.sendMessageToId(
          message,
          '2',
        );
      } catch (e) {
        expect(
          e,
          null,
          reason: 'should not throw exception',
        );
      }
      expect(
        () => communications.sendMessageToId(message, '2'),
        prints('Would send:\nMessage: ${message.toString()}\nTo: 2\n'),
        reason: 'should print message',
      );
      expect(
        message.runtimeType,
        Message,
        reason: 'should be Message',
      );
    });
    test('HandleMessage test', () {
      final possibleMessage = communications.handleMessage(message, '2');
      expect(
        possibleMessage,
        message,
        reason: 'should return the same message because own id is receiver',
      );
      final possibleMessage2 = communications.handleMessage(message, '1');
      expect(
        possibleMessage2,
        null,
        reason: 'should return null because own id is sender',
      );
    });
    test('sendNeighborsToId test', () {
      expect(
        () {
          communications.sendNeighborsToId(
            receiverId: 'receiver',
            ownId: 'me',
            devices: [DiscoverDevice(id: '1', username: '1')],
            route: [
              RouteNode(
                deviceId: 'me',
                isSender: true,
                isReceiver: false,
              ),
              RouteNode(
                deviceId: 'receiver',
                isSender: false,
                isReceiver: true,
              ),
            ],
            id: 'id',
          );
        },
        prints(
          'Would send:\nMessage: Message{id: id, senderId: me, receiverId: receiver, route: [RouteNode{deviceId: me, isSender: true, isReceiver: false}, RouteNode{deviceId: receiver, isSender: false, isReceiver: true}], payload: [{id: 1, username: 1, connectionStatus: null}], messageType: MessageType.neighborsResponse}\nTo: receiver\n',
        ),
      );
    });
    test('requestNeighbors test', () {
      expect(
        () {
          communications.requestNeighbors(
            receiverId: 'receiver',
            ownId: 'me',
            route: [
              RouteNode(
                deviceId: 'me',
                isSender: true,
                isReceiver: false,
              ),
              RouteNode(
                deviceId: 'receiver',
                isSender: false,
                isReceiver: true,
              ),
            ],
            id: 'id',
          );
        },
        prints(
          'Would send:\nMessage: Message{id: id, senderId: me, receiverId: receiver, route: [RouteNode{deviceId: me, isSender: true, isReceiver: false}, RouteNode{deviceId: receiver, isSender: false, isReceiver: true}], payload: null, messageType: MessageType.neighborsRequest}\nTo: receiver\n',
        ),
      );
    });
  });
}
