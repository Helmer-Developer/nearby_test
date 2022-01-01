import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/widgets/dialogs/dialogs.dart';
import 'package:nearby_test/widgets/main/main_widgets.dart';

///The main entry point for a dart application
///
///Adds the widget NearbyTestApp to the flutter engine
void main() {
  runApp(const NearbyTestApp());
}

///Root of the application
///
///Paints the "Advertise" and "Discover" buttons to the screen
///Adds AppBar with text and "Stop" button
///Asks user for required permissions and nickname
class NearbyTestApp extends StatefulWidget {
  const NearbyTestApp({Key? key}) : super(key: key);

  @override
  State<NearbyTestApp> createState() => _NearbyTestAppState();
}

class _NearbyTestAppState extends State<NearbyTestApp> {
  final nearby = Nearby();

  Future<void> initialise(BuildContext context) async {
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
      home: Builder(
        builder: (context) {
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
              children: const [
                AdvertiseWidget(),
                DiscoverWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
