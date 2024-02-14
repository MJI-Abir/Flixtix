import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moviflix/utils/commons.dart';

class TaskController {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future updateTask(BuildContext context,
      TextEditingController taskNameController, String taskId) async {
    String taskName = taskNameController.text;
    _firestore
        .collection('tasks')
        .doc(taskId)
        .update({'taskName': taskName})
        .then(
          (_) => showToast(
            message: "Task updated successfully",
          ),
        )
        .catchError(
          (error) => showToast(
            message: "Failed: $error",
          ),
        );
    Navigator.of(context).pop();
  }

  static Future deleteTask(String taskId) async {
    _firestore
        .collection('tasks')
        .doc(taskId)
        .delete()
        .then(
          (_) => showToast(
            message: "Task deleted successfully",
          ),
        )
        .catchError(
          (error) => showToast(
            message: "Failed: $error",
          ),
        );
  }

  static void checkboxChanged(String taskId, bool? value) async {
    await _firestore.collection('tasks').doc(taskId).update(
      {'isCompleted': value},
    );
  }
}
