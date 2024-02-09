import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskOperations {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static void saveNewTask(
      BuildContext context, TextEditingController taskNameController) async {
    String taskName = taskNameController.text;
    DateTime now = DateTime.now();
    DocumentReference docRef = await _firestore.collection('tasks').add(
      {
        'taskName': taskName,
        'isCompleted': false,
        'timestamp': now,
      },
    );
    String taskId = docRef.id;
    await _firestore.collection('tasks').doc(taskId).update(
      {'id': taskId},
    );
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  static Future updateTask(BuildContext context,
      TextEditingController taskNameController, String taskId) async {
    String taskName = taskNameController.text;
    _firestore
        .collection('tasks')
        .doc(taskId)
        .update({'taskName': taskName})
        .then(
          (_) => Fluttertoast.showToast(
            msg: "Task updated successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            fontSize: 14.0,
          ),
        )
        .catchError(
          (error) => Fluttertoast.showToast(
            msg: "Failed: $error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
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
          (_) => Fluttertoast.showToast(
            msg: "Task deleted successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            fontSize: 14.0,
          ),
        )
        .catchError(
          (error) => Fluttertoast.showToast(
            msg: "Failed: $error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          ),
        );
  }

  static void checkboxChanged(String taskId, bool? value) async {
    await _firestore.collection('tasks').doc(taskId).update(
      {'isCompleted': value},
    );
  }
}
