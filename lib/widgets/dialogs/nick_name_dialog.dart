part of 'dialogs.dart';

///Dialog to collect nickname of user
///
///Promts the user with a dialog and a text field to enter a nickname
class NickNameDialog extends ConsumerStatefulWidget {
  const NickNameDialog({Key? key}) : super(key: key);

  @override
  _NickNameDialogState createState() => _NickNameDialogState();
}

class _NickNameDialogState extends ConsumerState<NickNameDialog> {
  final controller = TextEditingController();
  @override
  void initState() {
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.nickNameDialogTitle),
      content: TextField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: controller.value.text.isNotEmpty
              ? () {
                  ///Storing nickname in a global variable
                  ///
                  ///Definitely not a long-term solution; will change in the future
                  ///Not safe and permantent storing
                  ref.read(meProvider).ownName = controller.value.text;
                  Navigator.pop(context);
                }
              : null,
          child: Text(
            AppLocalizations.of(context)!.nickNameDialogSubmitButtonText,
          ),
        ),
      ],
    );
  }
}
