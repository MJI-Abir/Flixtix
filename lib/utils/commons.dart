import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({
  required String message,
  Toast toastLength = Toast.LENGTH_LONG,
  ToastGravity gravity = ToastGravity.SNACKBAR,
  Color backgroundColor = Colors.yellow,
  Color textColor = Colors.black,
  double fontSize = 14.0,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: toastLength,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}
