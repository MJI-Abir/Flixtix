import "package:flutter/material.dart";
import "package:moviflix/utils/custom_dialog_box.dart";
import "package:moviflix/utils/todo_list_tile.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //controller
  final _controller = TextEditingController();
  // Todo default list
  List todoList = [
    ["Finish Homework", false],
    ["Do Exercise", false],
  ];

  // checklist is tapped
  void onChanged(int index, bool? value) {
    setState(() {
      todoList[index][1] = !todoList[index][1];
    });
  }

  // save new task to todo list
  void saveNewTask() {
    setState(() {
      todoList.add([_controller.text, false]);
    });
    Navigator.pop(context);
  }

  // open dialog box to create new task
  void openDialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
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
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return TodoListTile(
            taskName: todoList[index][0],
            isCompleted: todoList[index][1],
            onChanged: (value) => onChanged(index, value),
          );
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
