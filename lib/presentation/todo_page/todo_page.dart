import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviflix/service/firebase_service.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/custom_alert_dialog.dart';
import 'package:moviflix/widgets/custom_dialog_box_with_text_field.dart';
import 'package:moviflix/widgets/todo_list_tile.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _taskNameController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void openDialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialogBoxWithTextField(
          taskNameController: _taskNameController,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void openUpdateAlertDialog(String taskId, String taskName) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          onCancel: () => Navigator.of(context).pop(),
          onUpdate: () =>
              FirebaseService.updateTask(context, _taskNameController, taskId),
          taskNameController: _taskNameController,
          taskName: taskName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MANAGE YOUR TASKS",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        backgroundColor: MyColors.offWhiteLight,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('tasks')
            .orderBy('timestamp')
            .where('userId', isEqualTo: _auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.docs.map(
                (DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return TodoListTile(
                    taskName: data['taskName'],
                    isCompleted: data['isCompleted'],
                    onDelete: (context) =>
                        FirebaseService.deleteTask(data['id']),
                    onChanged: (value) =>
                        FirebaseService.checkboxChanged(data['id'], value),
                    onEditPressed: (context) =>
                        openUpdateAlertDialog(data['id'], data['taskName']),
                  );
                },
              ).toList(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('No Tasks'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black87,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.greyLight,
        shape: const CircleBorder(),
        onPressed: openDialogBox,
        child: const Icon(
          Icons.add,
          color: MyColors.offWhiteLight,
        ),
      ),
    );
  }
}
