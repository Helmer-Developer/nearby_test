part of '../protocol.dart';

class ConnectedDevicesGraph {
  ConnectedDevicesGraph(String ownId, String ownUsername) {
    me = DiscoverDevice(
        id: ownId,
        username: ownUsername,
        connectionStatus: ConnectionStatus.connected);
    graph.addEdges(me, {});
  }

  late final DiscoverDevice me;
  final graph = DirectedGraph<DiscoverDevice>(
    {},
    comparator: (a, b) => a.id.compareTo(b.id),
  );

  void addDeviceWithMe(DiscoverDevice device) {
    if (graph.contains(device)) return;
    graph.addEdges(device, {me});
    graph.addEdges(me, {device});
  }

  void removeDevice(DiscoverDevice device) {
    graph.remove(device);
  }

  void addDeviceWithAncestors(
      DiscoverDevice device, List<DiscoverDevice> ancestors) {
    graph.addEdges(device, ancestors.toSet());
    for (var ancestor in ancestors) {
      graph.addEdges(ancestor, {device});
    }
  }

  List<DiscoverDevice> getRoute(DiscoverDevice from, DiscoverDevice to) =>
      graph.path(from, to);

  @override
  String toString() => graph.toString();
}
