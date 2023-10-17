import 'package:flutter/material.dart';

Future<void> showWaitingPopup(BuildContext context, String message) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      child: Center(
        widthFactor: double.infinity,
        heightFactor: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    ),
  );
}
