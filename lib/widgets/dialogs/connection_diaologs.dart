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
    String id,
    BuildContext context,
    Nearby nearby,
  ) async {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (context) => Column(
        children: [
          Text(AppLocalizations.of(context)!.acceptConnectionFromId(id)),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                  nearby.acceptConnection(
                    id,
                    onPayLoadRecieved: (id, payload) {
                      ///Displays a toast (depending on OS level and software skin) whenever a device sends a message
                      Fluttertoast.showToast(
                        msg: String.fromCharCodes(
                          payload.bytes!.toList(),
                        ),
                      );
                    },
                  );
                  Navigator.pop<bool>(context, true);
                },
                child: Text(AppLocalizations.of(context)!.acceptConnectionButton),
              ),
              TextButton(
                onPressed: () {
                  nearby.rejectConnection(id);
                  Navigator.pop<bool>(context, false);
                },
                child: Text(AppLocalizations.of(context)!.rejectConnectionButton),
              ),
            ],
          )
        ],
      ),
    );
  }
}
