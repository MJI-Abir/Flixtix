import 'package:flutter/material.dart';
import 'package:moviflix/utils/custom_material_button.dart';

// ignore: must_be_immutable
class CustomAlertDialog extends StatelessWidget {
  CustomAlertDialog({
    super.key,
    required this.onCancel,
    required this.onDelete,
  });

  VoidCallback onDelete;
  VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.yellow[300],
        content: SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Delete'),
              const Text('Are you sure you want to delete the task?'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomMaterialButton(
                    text: "Cancel",
                    onPressed: onCancel,
                  ),
                  CustomMaterialButton(
                    text: "Delete",
                    onPressed: onDelete,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
