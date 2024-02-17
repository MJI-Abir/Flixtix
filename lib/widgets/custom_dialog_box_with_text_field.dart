import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:moviflix/utils/commons.dart";
import "package:moviflix/utils/my_colors.dart";
import "package:moviflix/widgets/custom_material_button.dart";

// ignore: must_be_immutable
class CustomDialogBoxWithTextField extends StatefulWidget {
  CustomDialogBoxWithTextField({
    super.key,
    required this.onCancel,
    required this.taskNameController,
  });
  VoidCallback onCancel;
  final TextEditingController taskNameController;

  @override
  State<CustomDialogBoxWithTextField> createState() =>
      _CustomDialogBoxWithTextFieldState();
}

class _CustomDialogBoxWithTextFieldState
    extends State<CustomDialogBoxWithTextField> {
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void saveNewTask(
      BuildContext context, TextEditingController taskNameController) async {
    String taskName = taskNameController.text;
    DateTime now = DateTime.now();
    setState(() {
      isLoading = true;
    });
    DocumentReference docRef = await _firestore.collection('tasks').add(
      {
        'taskName': taskName,
        'isCompleted': false,
        'timestamp': now,
        'userId': _auth.currentUser!.uid,
      },
    );
    String taskId = docRef.id;
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .update(
          {'id': taskId},
        )
        .then(
          (_) => showToast(
            message: "Task Created",
          ),
        )
        .catchError(
          (error) => showToast(
            message: "Failed: $error",
          ),
        );
    setState(() {
      isLoading = false;
    });
    widget.taskNameController.clear();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors.appBgColor,
      content: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              autofocus: true,
              controller: widget.taskNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),
            if (isLoading)
              const SpinKitThreeBounce(
                color: Colors.black,
                size: 20,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //save button
                CustomMaterialButton(
                  text: "Save",
                  onPressed: () {
                    saveNewTask(context, widget.taskNameController);
                  },
                ),
                const SizedBox(width: 10),
                // cancel button
                CustomMaterialButton(
                  text: "Cancel",
                  onPressed: widget.onCancel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
