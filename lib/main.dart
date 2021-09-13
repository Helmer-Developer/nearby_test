import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/test_classes.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const NearbyTestApp());
}

class NearbyTestApp extends StatefulWidget {
  const NearbyTestApp({Key? key}) : super(key: key);

  @override
  State<NearbyTestApp> createState() => _NearbyTestAppState();
}

class _NearbyTestAppState extends State<NearbyTestApp> {
  List<DiscoverDevice> discoverdDevices = [];
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
                discoverdDevices.clear();
                setState(() {});
              },
              icon: const Icon(Icons.stop),
            ),
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text('test'),
                        ),
                      ),
                  icon: const Icon(Icons.person));
            })
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    nearby.startAdvertising(
                      const Uuid().v4(),
                      Strategy.P2P_CLUSTER,
                      onConnectionInitiated: (id, info) {
                        print(
                          'new connection🆕 id: $id info: (token: ${info.authenticationToken}, name: ${info.endpointName})',
                        );
                        nearby.acceptConnection(id,
                            onPayLoadRecieved: (id, payload) {
                          print(
                              'got message 📰 id: $id, message ${payload.bytes}');
                          String message = String.fromCharCodes(payload.bytes!);
                          Fluttertoast.showToast(msg: message);
                        });
                      },
                      onConnectionResult: (id, Status status) {
                        print(
                          'connection result🎁 id: $id status: $status',
                        );
                      },
                      onDisconnected: (id) {
                        print('disconnected😢 $id');
                      },
                      serviceId: 'com.example.nearby_test',
                    );
                  },
                  child: Text(
                    'Advertise',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: discoverdDevices.isNotEmpty
                    ? ListView(
                        children: discoverdDevices
                            .map<ListTile>(
                              (device) => ListTile(
                                leading: device.connectionStatus ==
                                        MyConnectionStatus.waitng
                                    ? const CircularProgressIndicator()
                                    : null,
                                trailing: device.connectionStatus ==
                                        MyConnectionStatus.done
                                    ? IconButton(
                                        onPressed: () {
                                          nearby.sendBytesPayload(
                                            device.id,
                                            Uint8List.fromList("hi".codeUnits),
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.phonelink_ring_outlined),
                                      )
                                    : null,
                                title: Text(device.id),
                                subtitle: Text(device.username),
                                onTap: () async {
                                  nearby.requestConnection(
                                    device.username,
                                    device.id,
                                    onConnectionInitiated: (id, info) {
                                      print(
                                        'new connection🆕 id: $id info: (token: ${info.authenticationToken}, name: ${info.endpointName})',
                                      );
                                      nearby.acceptConnection(id,
                                          onPayLoadRecieved: (id, update) {
                                        print(
                                            'got message 📰 id: $id, message ${update.bytes}');
                                      });
                                      discoverdDevices
                                              .firstWhere(
                                                  (device) => device.id == id)
                                              .connectionStatus =
                                          MyConnectionStatus.done;
                                      setState(() {});
                                    },
                                    onConnectionResult: (id, status) {
                                      print(
                                        'connection result🎁 id: $id status: $status',
                                      );
                                    },
                                    onDisconnected: (id) {
                                      print('disconnected😢 $id');
                                    },
                                  );
                                  setState(() {
                                    device.connectionStatus =
                                        MyConnectionStatus.waitng;
                                  });
                                },
                              ),
                            )
                            .toList(),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        onPressed: () async {
                          await nearby.startDiscovery(
                            const Uuid().v4(),
                            Strategy.P2P_CLUSTER,
                            onEndpointFound: (id, username, serviceId) {
                              if (discoverdDevices
                                  .any((device) => device.id == id)) return;
                              discoverdDevices.add(
                                  DiscoverDevice(id: id, username: username));
                              setState(() {});
                            },
                            onEndpointLost: (id) {
                              discoverdDevices.removeWhere((device) =>
                                  device.id == id &&
                                  device.connectionStatus == null);
                              setState(() {});
                            },
                            serviceId: 'com.example.nearby_test',
                          );
                        },
                        child: Text(
                          'Discover',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
