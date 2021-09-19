import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nearby_connections/nearby_connections.dart';

class ConnectionDialogs {
  static void acceptConnection(String id, BuildContext context, Nearby nearby) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          Text('Möchtest du eine Anfrage von $id annehmen?'),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                  nearby.acceptConnection(id, onPayLoadRecieved: (id, payload) {
                    Fluttertoast.showToast(
                      msg: String.fromCharCodes(
                        payload.bytes!.toList(),
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text('Ja'),
              ),
              TextButton(
                onPressed: () {
                  nearby.rejectConnection(id);
                  Navigator.pop(context);
                },
                child: const Text('Nein'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
