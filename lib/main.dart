import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/widgets/dialogs/location_dialog.dart';
import 'package:nearby_test/widgets/main/discover_widget.dart';
import 'package:nearby_test/widgets/dialogs/nick_name_dialog.dart';
import 'widgets/main/advertise_widget.dart';

void main() {
  runApp(const NearbyTestApp());
}

class NearbyTestApp extends StatefulWidget {
  const NearbyTestApp({Key? key}) : super(key: key);

  @override
  State<NearbyTestApp> createState() => _NearbyTestAppState();
}

class _NearbyTestAppState extends State<NearbyTestApp> {
  final nearby = Nearby();

  initialise(BuildContext context) async {
    if (!await nearby.checkLocationPermission()) {
      await showDialog(
        context: context,
        builder: (context) => LocationDialog(),
      );
    }
    showDialog(
      context: context,
      builder: (context) => const NickNameDialog(),
    );
    await nearby.enableLocationServices();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        initialise(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Nearby Test'),
            actions: [
              IconButton(
                onPressed: () async {
                  await nearby.stopAdvertising();
                  await nearby.stopDiscovery();
                  await nearby.stopAllEndpoints();
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
        );
      }),
    );
  }
}
