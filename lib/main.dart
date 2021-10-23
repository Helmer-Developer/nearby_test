import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/discover_widget.dart';
import 'package:nearby_test/globals.dart';
import 'advertise_widget.dart';

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
        builder: (context) => AlertDialog(
          title: const Text('Standort'),
          content: const Text(
              'Deine Zustimmung ist erforderlich, damit die App funktioniert'),
          actions: [
            TextButton(
              onPressed: () async {
                if (await nearby.askLocationPermission()) {
                  Navigator.pop(context);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
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
        );
      }),
    );
  }
}

class NickNameDialog extends StatefulWidget {
  const NickNameDialog({Key? key}) : super(key: key);

  @override
  _NickNameDialogState createState() => _NickNameDialogState();
}

class _NickNameDialogState extends State<NickNameDialog> {
  final controller = TextEditingController();
  @override
  void initState() {
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('NickName'),
      content: TextField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: controller.value.text.isNotEmpty
              ? () {
                  nickName = controller.value.text;
                  Navigator.pop(context);
                }
              : null,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
