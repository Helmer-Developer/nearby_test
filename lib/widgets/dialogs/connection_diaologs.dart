part of './dialogs.dart';

///The abstract class for holding all dialogs associated with the Nearby Connections Api
///
///Currently holding only [acceptConnection]
abstract class ConnectionDialogs {

  ///Asking the user wether he/she wants to connect to another device 
  ///
  ///needs an [id], a [context] and an instance of the [Nearby]
  ///all parameters are requerd (implicitly)
  ///returns [bool] wether the user accepted the connection or not
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
                    ///Display a Toast (depending on OS level and software skin) when ever a divces sends a message
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
