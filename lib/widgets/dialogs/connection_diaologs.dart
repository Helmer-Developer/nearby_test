part of './dialogs.dart';

///The abstract class for containing all dialogs associated with the Nearby Connections API
///
///Currently containing only [acceptConnection]
abstract class ConnectionDialogs {

  ///Asking the user whether they want to connect to another device 
  ///
  ///Needs an [id], a [context] and an instance of the [Nearby]
  ///All parameters are required (implicitly)
  ///Returns [bool] whether the user accepted the connection or not
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
                    ///Displays a toast (depending on OS level and software skin) whenever a device sends a message
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
