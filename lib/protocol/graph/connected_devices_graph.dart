part of '../protocol.dart';

/// Class to implement a Graph of the connected devices
///
/// This class is used to create a graph of the connected devices.
/// To add a device to the graph, use ether the [addDeviceWithMe] function if the device is a directly connected device,
/// or the [addDeviceWithAncestors] function if you want to add devices which are ancestors of already added devices.
class ConnectedDevicesGraph extends ChangeNotifier {
  /// Constructor to initialize the graph with [ownId] and [ownUsername] as the root node (me)
  ConnectedDevicesGraph(String ownId, String ownUsername) {
    _me = DiscoveredDevice(
      id: ownId,
      username: ownUsername,
      connectionStatus: ConnectionStatus.connected,
    );
    _graph.addEdges(_me, {});
  }

  /// [DiscoveredDevice] object representing this device (me node)
  late final DiscoveredDevice _me;

  DiscoveredDevice get me => _me;

  /// [graph] with connected devices as nodes and edges between them
  /// comparing the [DiscoveredDevice.id]
  final _graph = DirectedGraph<DiscoveredDevice>(
    {},
    comparator: (a, b) => a.id.compareTo(b.id),
  );

  DirectedGraph<DiscoveredDevice> get graph => _graph;

  /// Adds a [DiscoveredDevice] to the graph with an edge to the root node [me]
  ///
  /// Only use this function if the device is a directly connected one.
  void addDeviceWithMe(DiscoveredDevice device) {
    if (_graph.contains(device)) return;
    _graph.addEdges(device, {_me});
    _graph.addEdges(_me, {device});
    notifyListeners();
  }

  void replaceOwnId(String newId) {
    final oldEdges = _graph.edges(_me).toList();
    _me.id = newId;
    _graph.addEdges(_me, oldEdges.toSet());
    notifyListeners();
  }

  /// Removes the [device] from the graph
  void removeDevice(DiscoveredDevice device) {
    _graph.remove(device);
    notifyListeners();
  }

  void removeDeviceById(String id) => removeDevice(DiscoveredDevice(id: id));

  /// Adds a [DiscoveredDevice] to the graph with an edge to all its ancestors
  ///
  /// Use this function if you want to add devices which are ancestors of already added devices.
  void addDeviceWithAncestors(
    DiscoveredDevice device,
    List<DiscoveredDevice> ancestors,
  ) {
    _graph.addEdges(device, ancestors.toSet());
    for (final ancestor in ancestors) {
      _graph.addEdges(ancestor, {device});
    }
    notifyListeners();
  }

  /// Replaces the [DiscoveredDevice] with the same [DiscoveredDevice.id] with the given properties from [device]
  void replaceDevice(DiscoveredDevice device) {
    (_graph.vertices.firstWhere((e) => e == device))
      ..connectionStatus = device.connectionStatus
      ..username = device.username;
    notifyListeners();
  }

  /// Clears the graph
  ///
  /// Removes all vertices and edges (devices) from the graph
  void clear() {
    _graph.clear();
    notifyListeners();
  }

  /// Returns a boolean indicating if the graph contains the [device]
  ///
  /// Note: Only compares the [DiscoveredDevice.id] due to == operator override
  bool contains(DiscoveredDevice device) => _graph.contains(device);

  /// Returns a boolean indicating if the graph contains a device with the given [id]
  bool containsById(String id) => contains(DiscoveredDevice(id: id));

  /// Returns a boolean indicating if the given [device] is directly connected to the root node [me]
  bool isConnectedToMe(DiscoveredDevice device) =>
      _graph.edges(_me).contains(device);

  /// Returns a boolean indicating if the device with the given [id] is directly connected to the root node [me]
  bool isConnectedToMeById(String id) =>
      isConnectedToMe(DiscoveredDevice(id: id));

  /// Returns a list of all devices in the graph which are connected to me
  ///
  /// This function is used to get a list of all devices which are connected to me.
  /// Returns all vertices which have a edge to me.
  List<DiscoveredDevice> connectedDevices() {
    return _graph.edges(_me).toList();
  }

  /// Returns the shortest path form [from] to [to]
  ///
  /// Returns a [List] of [RouteNode]s (converted from [DiscoveredDevice]s
  /// with [RouteNode.isSender] and [RouteNode.isReceiver] set to true at first and last node)
  /// or null if no path exists
  MessageRoute? getRoute(DiscoveredDevice from, DiscoveredDevice to) {
    final path = _graph.path(from, to);
    if (path.isEmpty) return null;
    final route = path
        .map<RouteNode>(
          (device) => RouteNode(
            deviceId: device.id,
            isSender: false,
            isReceiver: false,
          ),
        )
        .toList();
    route.first.isSender = true;
    route.last.isReceiver = true;
    return route;
  }

  /// Returns the shortest path form [fromId] to [toId]
  ///
  /// Returns a [List] of [RouteNode]s (converted from [DiscoveredDevice]s
  /// with [RouteNode.isSender] and [RouteNode.isReceiver] set to true at first and last node)
  /// or null if no path exists
  MessageRoute? getRouteById(String fromId, String toId) {
    return getRoute(DiscoveredDevice(id: fromId), DiscoveredDevice(id: toId));
  }

  /// Returns the device with the given [id] or null if no device with the given [id] exists
  DiscoveredDevice? getDeviceById(String id) {
    if (!contains(DiscoveredDevice(id: id))) return null;
    return _graph.vertices.firstWhere(
      (device) => device.id == id,
    );
  }

  /// Overriding the toString function to return the [graph] as a string representation
  @override
  String toString() => _graph.toString();
}

///enum to streamline handling of discovered devices
enum ConnectionStatus { waiting, connected, error }
