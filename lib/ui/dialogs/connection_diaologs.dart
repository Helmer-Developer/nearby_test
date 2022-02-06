part of '../ui.dart';

///The abstract class for containing all dialogs associated with the Nearby Connections API
///
/// Includes:
/// - [acceptConnection] to accept a connection request
/// - [connectWithAlreadyExistingDevice] to connect to a device that is already part of the network
abstract class ConnectionDialogs {
  ///Asking the user whether they want to connect to another device
  ///
  ///Needs an [id], a [context] and an instance of the [Nearby]
  ///All parameters are required (implicitly)
  ///Returns [bool] whether the user accepted the connection or not
  static Future<bool?> acceptConnection(
    String id,
    BuildContext context,
  ) async {
    return showModalBottomSheet<bool>(
      isDismissible: false,
      context: context,
      builder: (context) => Column(
        children: [
          Text(AppLocalizations.of(context)!.acceptConnectionFromId(id)),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop<bool>(context, true),
                child:
                    Text(AppLocalizations.of(context)!.acceptConnectionButton),
              ),
              TextButton(
                onPressed: () => Navigator.pop<bool>(context, false),
                child:
                    Text(AppLocalizations.of(context)!.rejectConnectionButton),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Asking the user wether they want to directly connect to another device that is already part of the network.
  /// 
  /// Needs an [id] and a [context].
  /// Shows a bottom sheet where the user can select whether they want to connect to the device or not.
  static Future<bool?> connectWithAlreadyExistingDevice(
    String id,
    BuildContext context,
  ) async {
    return showModalBottomSheet<bool>(
      isDismissible: false,
      context: context,
      builder: (context) => Column(
        children: [
          Text(
            AppLocalizations.of(context)!
                .connectToAlreadyExistingDeviceSheetTitle(id),
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop<bool>(context, true),
                child: Text(
                  AppLocalizations.of(context)!
                      .connectToAlreadyExistingDeviceSheetAcceptButton,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop<bool>(context, false),
                child: Text(
                  AppLocalizations.of(context)!
                      .connectToAlreadyExistingDeviceSheetRejectButton,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
