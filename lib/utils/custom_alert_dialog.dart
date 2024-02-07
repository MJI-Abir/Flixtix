import 'package:flutter/material.dart';

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
    return PopupMenuItem(
      value: 'delete',
      child: const Text(
        'Delete',
        style: TextStyle(fontSize: 13.0),
      ),
      onTap: () {},
    );
  }
}
