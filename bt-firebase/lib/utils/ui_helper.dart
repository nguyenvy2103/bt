import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
}

void hideLoading(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

void showSnackBar(BuildContext context, String msg, {bool success = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: success ? Colors.green : Colors.red,
    ),
  );
}
