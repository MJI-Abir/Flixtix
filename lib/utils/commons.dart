import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviflix/utils/my_colors.dart';

void showToast({
  required String message,
  Toast toastLength = Toast.LENGTH_LONG,
  ToastGravity gravity = ToastGravity.SNACKBAR,
  Color backgroundColor = MyColors.pasteColorLight,
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

void showErrorToast({
  required String message,
  Toast toastLength = Toast.LENGTH_LONG,
  ToastGravity gravity = ToastGravity.TOP_RIGHT,
  Color backgroundColor = const Color(0xFFFE4A49),
  Color textColor = Colors.white,
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

var smallSubtitleText = GoogleFonts.aBeeZee(
  textStyle: const TextStyle(fontSize: 12, color: Colors.black54),
);

Widget sBoxOfHeight10 = const SizedBox(height: 10);
Widget sBoxOfHeight20 = const SizedBox(height: 20);
Widget sBoxOfHeight25 = const SizedBox(height: 25);
Widget sBoxOfHeight30 = const SizedBox(height: 30);
