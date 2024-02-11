import "package:flutter/material.dart";

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
        backgroundColor: Theme.of(context).primaryColor,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}