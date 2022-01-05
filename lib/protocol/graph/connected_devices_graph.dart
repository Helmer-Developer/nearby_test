part of '../protocol.dart';

/// Class to implement a Graph of the connected devices
///
/// This class is used to create a graph of the connected devices.
/// To add a device to the graph, use eather the [addDeviceWithMe] functon if the device is a diricly connected device,
/// or the [addDeviceWithAncestors] function if you want to add devices which are acncestors of allready added devices.
class ConnectedDevicesGraph {
  /// Constructor to initailize the graph with [ownId] and [ownUsername] as the root node (me)
  ConnectedDevicesGraph(String ownId) {
    me = DiscoverDevice(
      id: ownId,
      username: ownId,
      connectionStatus: ConnectionStatus.connected,
    );
    graph.addEdges(me, {});
  }

  /// [DiscoverDevice] object representing the root node (me)
  late final DiscoverDevice me;

  /// [graph] with connected devices as nodes and edges between them
  /// compearing the [DiscoverDevice.id]
  final graph = DirectedGraph<DiscoverDevice>(
    {},
    comparator: (a, b) => a.id.compareTo(b.id),
  );

  /// Adds a [DiscoverDevice] to the graph wiht an edge to [me]
  ///
  /// Only use this function if the device is a diricly connected to the root node [me]
  void addDeviceWithMe(DiscoverDevice device) {
    if (graph.contains(device)) return;
    graph.addEdges(device, {me});
    graph.addEdges(me, {device});
  }

  /// Removes the [device] from the graph
  void removeDevice(DiscoverDevice device) {
    graph.remove(device);
  }

  /// Adds a [DiscoverDevice] to the graph with an edge to all its ancestors
  ///
  /// Use this function if you want to add devices which are acncestors of allready added devices.
  void addDeviceWithAncestors(
    DiscoverDevice device,
    List<DiscoverDevice> ancestors,
  ) {
    graph.addEdges(device, ancestors.toSet());
    for (final ancestor in ancestors) {
      graph.addEdges(ancestor, {device});
    }
  }

  /// Returns a list of all devices in the graph wich are connected to me
  ///
  /// This function is used to get a list of all devices which are connected to me.
  /// Returns all vertices wich have a edge to me.
  List<DiscoverDevice> connectedDevices() {
    return graph.edges(me).toList();
  }

  /// Generates the shortest paht form [from] to [to]
  ///
  /// Returns a [List] of [RouteNode]s (converted from [DiscoverDevice]s
  /// with [RouteNode.isSender] and [RouteNode.isReceiver] set to true at first and last node)
  MessageRoute? getRoute(DiscoverDevice from, DiscoverDevice to) {
    final path = graph.path(from, to);
    if (path.isEmpty) return null;
    final route = path
        .map<RouteNode>(
          (device) => RouteNode(
            deviceId: device.id,
            isSender: false,
            isReceiver: true,
          ),
        )
        .toList();
    route.first.isSender = true;
    route.last.isReceiver = true;
    return route;
  }

  /// Overriding the toString function to return the [graph] as a string representation
  @override
  String toString() => graph.toString();
}
