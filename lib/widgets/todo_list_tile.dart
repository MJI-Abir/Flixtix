import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:moviflix/utils/my_colors.dart";

// ignore: must_be_immutable
class TodoListTile extends StatelessWidget {
  final String taskName;
  final bool isCompleted;
  final Function(bool?)? onChanged;
  Function(BuildContext)? onDelete;
  final Function(BuildContext)? onEditPressed;
  TodoListTile({
    super.key,
    required this.taskName,
    required this.isCompleted,
    required this.onChanged,
    required this.onDelete,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 25.0, right: 25, top: 10, bottom: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: onEditPressed,
              icon: Icons.edit,
              label: "Edit",
              backgroundColor: MyColors.greyLight,
              foregroundColor: MyColors.offWhiteLight,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: onDelete,
              icon: Icons.delete,
              label: "Delete",
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: MyColors.offWhiteLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: MyColors.offWhiteLight,
                blurRadius: 2.0,
                offset: Offset(0, 5), // shadow direction: bottom right
              ),
            ],
          ),
          child: Row(
            children: [
              Checkbox(
                value: isCompleted,
                onChanged: onChanged,
                activeColor: MyColors.greyLight,
              ),
              Text(
                taskName,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "PoorStory",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
