import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nearby_connections/nearby_connections.dart';

///The abstract class for 
abstract class ConnectionDialogs {
  static Future<bool?> acceptConnection(
      String id, BuildContext context, Nearby nearby) async {
    return await showModalBottomSheet<bool>(
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
                  Navigator.pop<bool>(context, true);
                },
                child: const Text('Ja'),
              ),
              TextButton(
                onPressed: () {
                  nearby.rejectConnection(id);
                  Navigator.pop<bool>(context, false);
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
