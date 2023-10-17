import 'package:flutter/material.dart';

Future<String?> showRemarkDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();

  final AlertDialog dialog = AlertDialog(
    backgroundColor: Color.fromARGB(255, 33, 145, 126),
    title: Text('Remark'),
    content: TextField(
      autofocus: true,
      controller: controller,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          hintText: 'Enter a remark',
          hintStyle: TextStyle(color: Colors.black)),
    ),
    actions: [
      TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
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
