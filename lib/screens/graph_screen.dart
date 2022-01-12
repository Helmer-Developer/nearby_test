import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:nearby_test/protocol/protocol.dart';
import 'package:nearby_test/provider/provider.dart';

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
        title: const Text('Graph'),
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
            builder: (node) => Chip(
              label: Text((node.key!.value as DiscoverDevice).toString()),
              backgroundColor: (ref.watch(meProvider).ownId ==
                      (node.key!.value as DiscoverDevice).id)
                  ? Colors.blue
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
