import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_test/global/globals.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('DiscoverdDevices unit test', () {
    test('CopyWith test', () {
      nickName = 'test-name';
      final String id = const Uuid().v4();
      final device = DiscoverDevice(id: id, username: nickName);
      expect(device.id, id, reason: 'id and device id shall be the same');
      expect(
        device.username,
        'test-name',
        reason: 'device username shall be "test-name"',
      );
      expect(
        device.connectionStatus,
        null,
        reason: 'ConnectionStatus of device shall be null',
      );
      device.connectionStatus = ConnectionStatus.connected;
      expect(
        device.connectionStatus,
        ConnectionStatus.connected,
        reason: 'device connectionStatus shall now be connected',
      );
      final String newId = const Uuid().v4();
      DiscoverDevice newDevice = device.copyWith();
      newDevice = device.copyWith(id: newId);
      expect(newDevice.id, newId);
      expect(
        newDevice.id,
        isNot(equals(device.id)),
        reason:
            'new and old device id shall not be the same (random error possible but very unlikely)',
      );
    });
    test('to and from json test (for communication trough NCP)', () {
      final device = DiscoverDevice(
        id: const Uuid().v4(),
        username: 'test-username',
        connectionStatus: ConnectionStatus.connected,
      );
      final json = device.toJson();
      expect(json.runtimeType, String);
      final data = Uint8List.fromList(json.codeUnits);
      final newJson = String.fromCharCodes(data);
      expect(newJson.runtimeType, String);
      final newDevice = DiscoverDevice.fromJson(newJson);
      expect(device.id, newDevice.id);
      expect(device.connectionStatus, newDevice.connectionStatus);
      expect(device.username, newDevice.username);
    });
    test('toString test', () {
      final device = DiscoverDevice(
        id: const Uuid().v4(),
        username: 'test-username',
        connectionStatus: ConnectionStatus.connected,
      );
      expect(
        device.toString(),
        'DiscoverDevice(id: ${device.id}, username: ${device.username}, connectionStatus: ${device.connectionStatus})',
        reason:
            'toString shall return a string representation of the device including the id',
      );
    });
  });
}
