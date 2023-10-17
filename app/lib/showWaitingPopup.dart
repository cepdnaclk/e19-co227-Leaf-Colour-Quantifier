import 'package:flutter/material.dart';

Future<void> showWaitingPopup(BuildContext context, String message) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.black.withOpacity(0.1),
      child: Center(
        widthFactor: double.infinity,
        heightFactor: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 33, 145, 126)),
            ),
          ],
        ),
      ),
    ),
  );
}
