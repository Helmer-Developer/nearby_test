part of '../ui.dart';

/// GraphScreen visualizes the data of the current map.
///
/// Displays all device of the network and their relations to each other.
class GraphScreen extends ConsumerWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(graphProvider);
    final newGraph = Graph();
    for (final node in graph.graph.vertices) {
      for (final edge in graph.graph.edges(node)) {
        newGraph.addEdge(Node.Id(node), Node.Id(edge));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.graphScreenTitle),
      ),
      body: Center(
        child: InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(1000),
          minScale: 0.01,
          maxScale: 5.6,
          child: GraphView(
            graph: newGraph,
            algorithm: FruchtermanReingoldAlgorithm(),
            builder: (node) {
              final device = node.key!.value as DiscoveredDevice;
              return ActionChip(
                label: Text(device.toString()),
                onPressed: () {
                  if (graph.me == device) return;
                  final route = graph.getRoute(
                    DiscoveredDevice(id: graph.me.id),
                    DiscoveredDevice(id: device.id),
                  );
                  if (route == null) return;
                  communication.sendTextToId(
                    receiverId: device.id,
                    ownId: graph.me.id,
                    text: 'Hi from ${graph.me.id}',
                    route: route,
                  );
                },
                backgroundColor: graph.me == device ? Colors.blue : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
