import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_test/global/globals.dart';
import 'package:nearby_test/protocol/protocol.dart';

void main() {
  group('Graph Test', () {
    test('Simple graph test', () {
      final graph = dummyGraph();
      final List<DiscoverDevice> devices = List.generate(
        8,
        (index) => DiscoverDevice(
          id: '$index',
          username: '$index',
          connectionStatus: ConnectionStatus.connected,
        ),
      );
      final me = graph.me;
      expect(graph.me.id, 'me',
          reason: 'test graph should be created with dummyGraph');
      expect(graph.graph.vertices.length, 9,
          reason: 'test graph should have 9 vertices (8 devices + me)');
      expect(
        graph.graph.data[devices[4]],
        {devices[2], devices[0], devices[5]},
        reason: 'the 4th device should be connected to 2, 0 and 5',
      );
      expect(
        graph.getRoute(me, devices[2]),
        [me, devices[1], devices[2]],
        reason: 'the route from me to 2 should be [me, 1, 2]',
      );
      graph.removeDevice(devices[1]);
      expect(
        graph.getRoute(me, devices[2]),
        [me, devices[0], devices[4], devices[2]],
        reason: 'the route from me to 2 should be [me, 0, 4, 2], because 1 is removed',
      );
    });
  });
}

ConnectedDevicesGraph dummyGraph() {
  final graph = ConnectedDevicesGraph('me', 'me');
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
