import 'package:flutter/material.dart';
import 'package:moviflix/utils/custom_material_button.dart';

// ignore: must_be_immutable
class CustomAlertDialog extends StatelessWidget {
  CustomAlertDialog({
    super.key,
    required this.onCancel,
    required this.onUpdate,
    required this.taskNameController,
    required this.taskName,
  });

  VoidCallback onUpdate;
  VoidCallback onCancel;
  final String taskName;
  final TextEditingController taskNameController;

  @override
  Widget build(BuildContext context) {
    print('taskName: $taskName');
    taskNameController.text = taskName;
    return AlertDialog(
        backgroundColor: Colors.yellow[300],
        content: SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                autofocus: true,
                controller: taskNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomMaterialButton(
                    text: "Cancel",
                    onPressed: onCancel,
                  ),
                  const SizedBox(width: 10),
                  CustomMaterialButton(
                    text: "Update",
                    onPressed: onUpdate,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
