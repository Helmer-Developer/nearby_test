part of 'main_widgets.dart';

///The advertising widget enabling NCA advertisement
///
///Displays an advertising Button to start advertising
///If one or more connectd device exists, will display information about device
class AdvertiseWidget extends StatefulWidget {
  const AdvertiseWidget({Key? key}) : super(key: key);

  @override
  _AdvertiseWidgetState createState() => _AdvertiseWidgetState();
}

class _AdvertiseWidgetState extends State<AdvertiseWidget> {
  final String nickName = 'nickname';
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
                        subtitle: Text(device.username ?? ''),
                        leading: device.connectionStatus ==
                                ConnectionStatus.connected
                            ? IconButton(
                                onPressed: () {
                                  nearby.disconnectFromEndpoint(device.id);
                                  setState(() {
                                    discoverdDevices.removeWhere(
                                      (device) => device.id == device.id,
                                    );
                                  });
                                },
                                icon: const Icon(Icons.stop),
                              )
                            : null,
                        trailing: device.connectionStatus ==
                                ConnectionStatus.connected
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
                    nickName,
                    Strategy.P2P_CLUSTER,
                    onConnectionInitiated: (id, info) async {
                      print(
                        'new connection🆕 id: $id info: (token: ${info.authenticationToken}, name: ${info.endpointName})',
                      );
                      if (await ConnectionDialogs.acceptConnection(
                            id,
                            context,
                            nearby,
                          ) ??
                          false) {
                        discoverdDevices.add(
                          DiscoverDevice(
                            id: id,
                            username: info.endpointName,
                            connectionStatus: ConnectionStatus.waiting,
                          ),
                        );
                      }
                    },
                    onConnectionResult: (id, Status status) {
                      print(
                        'connection result🎁 id: $id status: $status',
                      );
                      if (status == Status.CONNECTED) {
                        setState(() {
                          discoverdDevices
                              .firstWhere((device) => device.id == id)
                              .connectionStatus = ConnectionStatus.connected;
                        });
                      }
                    },
                    onDisconnected: (id) {
                      setState(() {
                        discoverdDevices
                            .removeWhere((device) => device.id == id);
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
