import 'package:flutter/material.dart';
import 'package:nearby_test/global/globals.dart';

class NickNameDialog extends StatefulWidget {
  const NickNameDialog({Key? key}) : super(key: key);

  @override
  _NickNameDialogState createState() => _NickNameDialogState();
}

class _NickNameDialogState extends State<NickNameDialog> {
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
      title: const Text('NickName'),
      content: TextField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: controller.value.text.isNotEmpty
              ? () {
                  nickName = controller.value.text;
                  Navigator.pop(context);
                }
              : null,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
