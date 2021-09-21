import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/discover_widget.dart';
import 'advertise_widget.dart';

voi main() {
  runApp(const NearbyTestApp());
}

class NearbyTestApp extends StatefulWidget {
  const NearbyTestApp({Key? key}) : super(key: key);

  @override
  State<NearbyTestApp> createState() => _NearbyTestAppState();
}

class _NearbyTestAppState extends State<NearbyTestApp> {
  final nearby = Nearby();

  initialise() async {
    await nearby.askLocationPermission();
    await nearby.enableLocationServices();
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Test'),
          actions: [
            IconButton(
              onPressed: () async {
                await nearby.stopAdvertising();
                await nearby.stopDiscovery();
                await nearby.stopAllEndpoints();
                setState(() {});
              },
              icon: const Icon(Icons.stop),
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: const [
            AdvertiseWidget(),
            DiscoverWidget(),
          ],
        ),
      ),
    );
  }
}
