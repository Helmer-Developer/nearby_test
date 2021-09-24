import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:nearby_test/test_classes.dart';
import 'package:uuid/uuid.dart';

import 'connection_diaologs.dart';

class AdvertiseWidget extends StatefulWidget {
  const AdvertiseWidget({Key? key}) : super(key: key);

  @override
  _AdvertiseWidgetState createState() => _AdvertiseWidgetState();
}

class _AdvertiseWidgetState extends State<AdvertiseWidget> {
  final nearby = Nearby();
  List<DiscoverDevice> discoverdDevices = [];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: discoverdDevices.isNotEmpty
            ? ListView(
                children: discoverdDevices
                    .map(
                      (device) => ListTile(
                        title: Text(device.id),
                        leading:
                            device.connectionStatus == ConnectionStatus.done
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
                      ),
                    )
                    .toList(),
              )
            : ElevatedButton(
                onPressed: () async {
                  nearby.startAdvertising(
                    const Uuid().v4(),
                    Strategy.P2P_CLUSTER,
                    onConnectionInitiated: (id, info) {
                      print(
                        'new connection🆕 id: $id info: (token: ${info.authenticationToken}, name: ${info.endpointName})',
                      );
                      ConnectionDialogs.acceptConnection(id, context, nearby);
                    },
                    onConnectionResult: (id, Status status) {
                      print(
                        'connection result🎁 id: $id status: $status',
                      );
                      if (status == Status.CONNECTED) {
                        discoverdDevices.add(
                          DiscoverDevice(
                            id: id,
                            username: 'unknown',
                            connectionStatus: ConnectionStatus.done,
                          ),
                        );
                        setState(() {});
                      }
                    },
                    onDisconnected: (id) {
                      setState(() {
                        discoverdDevices.removeWhere((device) =>
                            device.id == id );
                      });
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
    );
  }
}
