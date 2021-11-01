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
      title: const Text('Standort'),
      content: const Text(
          'Deine Zustimmung ist erforderlich, damit die App funktioniert'),
      actions: [
        TextButton(
          onPressed: () async {
            if (await nearby.askLocationPermission()) {
              Navigator.pop(context);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
