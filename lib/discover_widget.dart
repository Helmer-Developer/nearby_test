import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'connection_diaologs.dart';
import 'globals.dart';
import 'test_classes.dart';

class DiscoverWidget extends StatefulWidget {
  const DiscoverWidget({Key? key}) : super(key: key);

  @override
  _DiscoverWidgetState createState() => _DiscoverWidgetState();
}

class _DiscoverWidgetState extends State<DiscoverWidget> {
  List<DiscoverDevice> discoverdDevices = [];
  final nearby = Nearby();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: discoverdDevices.isNotEmpty
            ? ListView(
                children: discoverdDevices
                    .map<ListTile>(
                      (device) => ListTile(
                        leading: device.connectionStatus ==
                                ConnectionStatus.waitng
                            ? const CircularProgressIndicator()
                            : device.connectionStatus == ConnectionStatus.done
                                ? IconButton(
                                    onPressed: () {
                                      nearby.disconnectFromEndpoint(device.id);
                                      setState(() {
                                        discoverdDevices.removeWhere(
                                            (device) => device.id == device.id);
                                      });
                                    },
                                    icon: const Icon(Icons.stop),
                                  )
                                : null,
                        trailing: device.connectionStatus ==
                                ConnectionStatus.done
                            ? IconButton(
                                onPressed: () {
                                  nearby.sendBytesPayload(
                                    device.id,
                                    Uint8List.fromList('hi'.codeUnits),
                                  );
                                },
                                icon: const Icon(Icons.phonelink_ring_outlined),
                              )
                            : null,
                        title: Text(device.id),
                        subtitle: Text(device.username),
                        onTap: () async {
                          nearby.requestConnection(
                            nickName,
                            device.id,
                            onConnectionInitiated: (id, info) async {
                              print(
                                'new connection🆕 id: $id info: (token: ${info.authenticationToken}, name: ${info.endpointName})',
                              );
                              ConnectionDialogs.acceptConnection(
                                  id, context, nearby);
                            },
                            onConnectionResult: (id, status) {
                              print(
                                'connection result🎁 id: $id status: $status',
                              );
                              if (status == Status.CONNECTED) {
                                final device =
                                    discoverdDevices.firstWhere((device) {
                                  print('compairng $id and ${device.id}');
                                  return device.id == id;
                                });
                                device.connectionStatus = ConnectionStatus.done;
                                setState(() {});
                              }
                            },
                            onDisconnected: (id) {
                              print('lost connection to $id');
                              setState(() {
                                discoverdDevices.removeWhere((device) =>
                                    device.id == id );
                              });
                            },
                          );
                          setState(() {
                            device.connectionStatus = ConnectionStatus.waitng;
                          });
                        },
                      ),
                    )
                    .toList(),
              )
            : ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () async {
                  await nearby.startDiscovery(
                    nickName,
                    Strategy.P2P_CLUSTER,
                    onEndpointFound: (id, username, serviceId) {
                      if (discoverdDevices.any((device) => device.id == id)) {
                        return;
                      }
                      discoverdDevices
                          .add(DiscoverDevice(id: id, username: username));
                      setState(() {});
                    },
                    onEndpointLost: (id) {
                      print('lost connection to $id');
                      setState(() {
                        discoverdDevices.removeWhere((device) =>
                            device.id == id );
                      });
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
    );
  }
}
