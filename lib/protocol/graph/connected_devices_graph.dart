part of '../protocol.dart';

/// Class to implement a Graph of the connected devices
///
/// This class is used to create a graph of the connected devices.
/// To add a device to the graph, use eather the [addDeviceWithMe] functon if the device is a diricly connected device,
/// or the [addDeviceWithAncestors] function if you want to add devices which are acncestors of allready added devices.
class ConnectedDevicesGraph extends ChangeNotifier {
  /// Constructor to initailize the graph with [ownId] and [ownUsername] as the root node (me)
  ConnectedDevicesGraph(String ownId, String ownUsername) {
    _me = DiscoverDevice(
      id: ownId,
      username: ownUsername,
      connectionStatus: ConnectionStatus.connected,
    );
    _graph.addEdges(_me, {});
  }

  /// [DiscoverDevice] object representing this device (me node)
  late final DiscoverDevice _me;

  DiscoverDevice get me => _me;

  /// [graph] with connected devices as nodes and edges between them
  /// compearing the [DiscoverDevice.id]
  final _graph = DirectedGraph<DiscoverDevice>(
    {},
    comparator: (a, b) => a.id.compareTo(b.id),
  );

  DirectedGraph<DiscoverDevice> get graph => _graph;

  /// Adds a [DiscoverDevice] to the graph wiht an edge to [me]
  ///
  /// Only use this function if the device is a diricly connected to the root node [me]
  void addDeviceWithMe(DiscoverDevice device) {
    if (_graph.contains(device)) return;
    _graph.addEdges(device, {_me});
    _graph.addEdges(_me, {device});
    notifyListeners();
  }

  /// Removes the [device] from the graph
  void removeDevice(DiscoverDevice device) {
    _graph.remove(device);
    notifyListeners();
  }

  /// Adds a [DiscoverDevice] to the graph with an edge to all its ancestors
  ///
  /// Use this function if you want to add devices which are acncestors of allready added devices.
  void addDeviceWithAncestors(
    DiscoverDevice device,
    List<DiscoverDevice> ancestors,
  ) {
    _graph.addEdges(device, ancestors.toSet());
    for (final ancestor in ancestors) {
      _graph.addEdges(ancestor, {device});
    }
    notifyListeners();
  }

  void replaceDevice(DiscoverDevice device) {
    (_graph.vertices.firstWhere((e) => e == device))
      ..connectionStatus = device.connectionStatus
      ..username = device.username;
    notifyListeners();
  }

  bool contains(DiscoverDevice device) => _graph.contains(device);

  /// Returns a list of all devices in the graph wich are connected to me
  ///
  /// This function is used to get a list of all devices which are connected to me.
  /// Returns all vertices wich have a edge to me.
  List<DiscoverDevice> connectedDevices() {
    return _graph.edges(_me).toList();
  }

  /// Generates the shortest paht form [from] to [to]
  ///
  /// Returns a [List] of [RouteNode]s (converted from [DiscoverDevice]s
  /// with [RouteNode.isSender] and [RouteNode.isReceiver] set to true at first and last node)
  MessageRoute? getRoute(DiscoverDevice from, DiscoverDevice to) {
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

  DiscoverDevice? getDeviceById(String id) {
    if(!contains(DiscoverDevice(id: id, username: id))) return null;
    return _graph.vertices.firstWhere((device) => device.id == id,);
  }

  /// Overriding the toString function to return the [graph] as a string representation
  @override
  String toString() => _graph.toString();
}
