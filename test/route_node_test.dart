import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_test/protocol/communication/communication.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:uuid/uuid.dart';

main() {
  group('RouteNode Basic test', () {
    test('Device id equals generated id', () {
      final id = const Uuid().v4();
      final RouteNode routeNode = RouteNode(
        deviceId: id,
        isSender: false,
        isReceiver: false,
      );
      expect(routeNode.deviceId, id,
          reason: 'RouteNode.deviceId shall be equale to id');
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
    test('trigger assert falue', () {
      try {
        // ignore: unused_local_variable
        final RouteNode routeNode = RouteNode(
          deviceId: '0',
          isSender: true,
          isReceiver: true,
        );
      } catch (e) {
        final asssertionError = e as AssertionError;
        expect(asssertionError.message,
            'isSender and isReciver can not be true at the same time');
      }
    });
  });
}
