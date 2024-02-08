import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:moviflix/utils/custom_alert_dialog.dart";
import 'package:moviflix/utils/custom_dialog_box_with_text_field.dart';
import "package:moviflix/utils/todo_list_tile.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //controller
  final _taskNameController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  // Todo default list
  List todoList = [
    ["Finish Homework", false],
    ["Do Exercise", false],
  ];

  // save new task to todo list
  void saveNewTask() async {
    String taskName = _taskNameController.text;
    DocumentReference docRef = await _firestore.collection('tasks').add(
      {
        'taskName': taskName,
        'isCompleted': false,
      },
    );
    String taskId = docRef.id;
    await _firestore.collection('tasks').doc(taskId).update(
      {'id': taskId},
    );
    setState(() {
      _taskNameController.clear();
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  // open dialog box to create new task
  void openDialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialogBoxWithTextField(
          taskNameController: _taskNameController,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete a task from the todoList
  Future deleteTask(String taskId) async {
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
            timeInSecForIosWeb: 1,
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
    setState(() {});
  }

  // checklist is tapped
  void checkboxChanged(String taskId, bool? value) async {
    await _firestore.collection('tasks').doc(taskId).update(
      {'isCompleted': value},
    );
    setState(() {});
  }

  void openAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(onCancel: () {}, onDelete: () {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flixtix",
          style: TextStyle(fontFamily: "SingleDay"),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.yellow[300],
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('tasks').snapshots(),
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
                    onDelete: (context) => deleteTask(data['id']),
                    onChanged: (value) => checkboxChanged(data['id'], value),
                  );
                },
              ).toList(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('No Tasks'),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        onPressed: openDialogBox,
        child: const Icon(Icons.add),
      ),
    );
  }
}
