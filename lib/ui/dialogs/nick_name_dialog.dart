part of '../ui.dart';

/// Dialog to collect nickname of user
///
/// Prompts the user with a dialog and a text field to enter a nickname
/// Automatically updates the nickname in the [Me] provider instance
/// Automatically disables the submit button if the nickname is empty
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
