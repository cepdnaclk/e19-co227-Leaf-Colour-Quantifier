import 'package:flutter/material.dart';

Future<String?> showRemarkDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();

  final AlertDialog dialog = AlertDialog(
    title: Text('Remark'),
    content: TextField(
      autofocus: true,
      controller: controller,
      decoration: InputDecoration(hintText: 'Enter a remark'),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(controller.text);
        },
        child: Text('Submit'),
      ),
    ],
  );

  final String? remark = await showDialog<String>(
    context: context,
    builder: (context) => dialog,
  );

  return remark;
}
