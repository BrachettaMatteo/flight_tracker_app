import 'package:flutter/material.dart';

SnackBar snackBarCustom({required isCorrect, required String message}) {
  return SnackBar(
      content: Text(message),
      backgroundColor:
          isCorrect ? Colors.green.shade400 : Colors.redAccent.shade400);
}
