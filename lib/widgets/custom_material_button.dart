import "package:flutter/material.dart";
import "package:moviflix/utils/my_colors.dart";

// ignore: must_be_immutable
class CustomMaterialButton extends StatelessWidget {
  CustomMaterialButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.greyLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(color: MyColors.offWhiteLight),
      ),
    );
  }
}
