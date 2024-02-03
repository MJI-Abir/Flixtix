import "package:flutter/material.dart";
import "package:moviflix/utils/custom_material_button.dart";

// ignore: must_be_immutable
class CustomDialogBox extends StatelessWidget {
  CustomDialogBox({
    super.key,
    required this.onSave,
    required this.onCancel,
    required this.controller,
  });
  VoidCallback onSave;
  VoidCallback onCancel;
  final controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[300],
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              autofocus: true,
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //save button
                CustomMaterialButton(
                  text: "Save",
                  onPressed: onSave,
                ),
                const SizedBox(width: 10),
                // cancel button
                CustomMaterialButton(
                  text: "Cancel",
                  onPressed: onCancel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
