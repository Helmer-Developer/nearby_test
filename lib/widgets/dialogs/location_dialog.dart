part of 'dialogs.dart';

///Dialog to inform the user about required location permission
///
///Prompts the user with a dialog to ask for location permission
class LocationDialog extends StatelessWidget {
  LocationDialog({
    Key? key,
  }) : super(key: key);

  final Nearby nearby = Nearby();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.requestLocationPermissionDialogTitle,
      ),
      content: Text(
        AppLocalizations.of(context)!.requestLocationPermissionDialogMessage,
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (await nearby.askLocationPermission()) {
              Navigator.pop(context);
            }
          },
          child: Text(
            AppLocalizations.of(context)!.requestLocationPermissionButton,
          ),
        ),
      ],
    );
  }
}
