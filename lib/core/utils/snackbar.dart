import 'package:flutter/material.dart';

extension SnackbarX on BuildContext {
  void showMessage(String message, {String? actionLabel, VoidCallback? onAction}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: actionLabel == null
              ? null
              : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
        ),
      );
  }
}
