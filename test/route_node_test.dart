import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('RouteNode Basic test', () {
    test('Device id equals generated id', () {
      final id = const Uuid().v4();
      final RouteNode routeNode = RouteNode(
        deviceId: id,
        isSender: false,
        isReceiver: false,
      );
      expect(
        routeNode.deviceId,
        id,
        reason: 'RouteNode.deviceId shall be equal to id',
      );
    });
    test('RouteNode isSender and isReceiver test', () {
      final random = Random();
      late bool sender;
      late bool receiver;
      sender = random.nextBool();
      receiver = random.nextBool();

      while (sender && receiver) {
        sender = random.nextBool();
        receiver = random.nextBool();
      }
      final RouteNode routeNode = RouteNode(
        deviceId: '0',
        isReceiver: receiver,
        isSender: sender,
      );
      expect(routeNode.isReceiver, receiver);
      expect(routeNode.isSender, sender);
    });
    test('trigger assert fault', () {
      try {
        // ignore: unused_local_variable
        final RouteNode routeNode = RouteNode(
          deviceId: '0',
          isSender: true,
          isReceiver: true,
        );
      } catch (e) {
        final assertionError = e as AssertionError;
        expect(
          assertionError.message,
          'isSender and isReceiver can not be true at the same time',
        );
      }
    });
    test('RouteNode to and form Map test', () {
      final RouteNode node =
          RouteNode(deviceId: 'test', isSender: false, isReceiver: false);
      final map = node.toMap();
      final nodeFromMap = RouteNode.fromMap(map);
      expect(node, nodeFromMap, reason: 'Node and NodeFromMap shall be equal');
    });
    test('hash code equality test', () {
      final node1 = RouteNode(
        deviceId: 'test',
        isSender: false,
        isReceiver: false,
      );
      final node2 = RouteNode(
        deviceId: 'test',
        isSender: false,
        isReceiver: false,
      );
      expect(
        node1.hashCode,
        node2.hashCode,
        reason: 'Node1 and Node2 hashCode shall be equal',
      );
    });
  });
}
