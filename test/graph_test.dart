import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_test/global/globals.dart';
import 'package:nearby_test/protocol/protocol.dart';

void main() {
  group('Graph Test', () {
    test('unified graph test', () {
      final graph = dummyGraph();
      final devices = dummyDevices();
      final me = graph.me;
      expect(
        me.id,
        'me',
        reason: 'test graph should be created with dummyGraph',
      );
      expect(
        graph.graph.vertices.length,
        9,
        reason: 'test graph should have 9 vertices (8 devices + me)',
      );
      expect(
        graph.graph.data[devices[4]],
        {devices[2], devices[0], devices[5]},
        reason: 'the 4th device should be connected to 2, 0 and 5',
      );
      expect(
        graph.getRoute(me, devices[2])!.map<String>((e) => e.deviceId).toList(),
        ['me', '1', '2'],
        reason: 'the route from me to 2 should be [me, 1, 2]',
      );
      graph.removeDevice(devices[1]);
      expect(
        graph.getRoute(me, devices[2])!.map<String>((e) => e.deviceId).toList(),
        ['me', '0', '4', '2'],
        reason:
            'the route from me to 2 should be [me, 0, 4, 2], because 1 is removed',
      );
    });
    test('route Test', () {
      final graph = dummyGraph();
      final devices = dummyDevices();
      final route = graph.getRoute(devices[2], devices[0]);
      expect(
        route!.map<String>((e) => e.deviceId).toList(),
        ['2', '4', '0'],
        reason: 'the route from 2 to 0 should be [2, 4, 0]',
      );
      expect(
        route.first.isSender,
        true,
        reason: 'the first device should be the sender',
      );
      expect(
        route.last.isReceiver,
        true,
        reason: 'the last device should be the receiver',
      );
    });
    test('Connected Devices Test', () {
      final graph = dummyGraph();
      final devices = dummyDevices();
      final connectedDevices = graph.connectedDevices();
      expect(connectedDevices, [devices[0], devices[1], devices[7]]);
    });
    test('toString test', () {
      final graph = ConnectedDevicesGraph('me');
      graph.addDeviceWithMe(
        DiscoverDevice(
          id: '1',
          username: '1',
          connectionStatus: ConnectionStatus.connected,
        ),
      );
      expect(
        graph.toString(),
        '{\n DiscoverDevice(id: 1): {DiscoverDevice(id: me)},\n DiscoverDevice(id: me): {DiscoverDevice(id: 1)},\n}',
        reason: 'toString should return a string representation of the graph',
      );
    });
  });
}

ConnectedDevicesGraph dummyGraph() {
  final graph = ConnectedDevicesGraph('me');
  final List<DiscoverDevice> devices = List.generate(
    8,
    (index) => DiscoverDevice(
      id: '$index',
      username: '$index',
      connectionStatus: ConnectionStatus.connected,
    ),
  );
  graph.addDeviceWithMe(devices[0]);
  graph.addDeviceWithMe(devices[1]);
  graph.addDeviceWithAncestors(devices[1], [devices[2], devices[3]]);
  graph.addDeviceWithAncestors(devices[2], [devices[4]]);
  graph.addDeviceWithAncestors(devices[4], [devices[0], devices[5]]);
  graph.addDeviceWithAncestors(devices[5], [devices[6]]);
  graph.addDeviceWithAncestors(devices[5], [devices[0]]);
  graph.addDeviceWithMe(devices[7]);
  graph.addDeviceWithAncestors(devices[7], [devices[3]]);
  graph.addDeviceWithAncestors(devices[7], [devices[5]]);
  return graph;
}

List<DiscoverDevice> dummyDevices() => List.generate(
      8,
      (index) => DiscoverDevice(
        id: '$index',
        username: '$index',
        connectionStatus: ConnectionStatus.connected,
      ),
    );
