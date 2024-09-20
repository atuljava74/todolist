import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/model/task.dart';
import 'package:todolist/screens/edit_task.dart';
import 'package:todolist/services/database_service.dart';
import 'package:todolist/utils/utils.dart';
import 'package:todolist/viewmodels/home_vm.dart';
import 'package:todolist/widgets/icon_widget.dart';

class TodoListWidget extends StatefulWidget {
  final Task task;
  final Function toggleTaskCompleted;
  final Function refreshPage;
  final EdgeInsets? margin;

  const TodoListWidget({
    Key? key,
    required this.task,
    required this.refreshPage,
    required this.toggleTaskCompleted,
    this.margin,
  }) : super(key: key);

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Container styling
      margin:
          widget.margin ?? EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.task.isCompleted
              ? Color.fromRGBO(0, 255, 64, 1)
              : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // Main Row
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox IconButton
          GestureDetector(
            onTap: () => widget.toggleTaskCompleted(),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                widget.task.isCompleted
                    ? CupertinoIcons.checkmark_alt_circle_fill
                    : Icons.radio_button_unchecked,
                color: widget.task.isCompleted
                    ? Color.fromRGBO(0, 255, 64, 1)
                    : Colors.grey,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Title
                Text(
                  widget.task.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Jost',
                  ),
                ),
                const SizedBox(height: 4),
                // Task Description
                Text(
                  widget.task.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff7D7D7D),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Jost',
                  ),
                ),
                const SizedBox(height: 8),
                // Date and Time
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${widget.task.date.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Jost',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Popup Menu Button
          PopupMenuButton<int>(
            color: Colors.white,
            icon: const Icon(Icons.more_vert, size: 24, color: Colors.grey),
            onSelected: (value) {
              if (value == 0) {
                // TODO: Implement edit task logic here
              } else if (value == 1) {
                // TODO: Implement delete task logic here
              }
            },
            itemBuilder: (context) => [
              // Edit Option
              PopupMenuItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTaskPage(
                        taskId: widget.task.id,
                        initialTitle: widget.task.title,
                        initialDescription: widget.task.description,
                        initialDate: widget.task.date,
                        userId: Utils.userId,
                        refreshPageCallback: () => widget.refreshPage(),
                      ),
                    ),
                  );
                },
                value: 0,
                child: Row(
                  children: [
                    IconWidget(icon: 'assets/edit.svg', height: 30),
                    const SizedBox(width: 12),
                    const Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Jost',
                      ),
                    ),
                  ],
                ),
              ),
              // Delete Option
              PopupMenuItem(
                onTap: () async {
                  DatabaseService _databaseService =
                      DatabaseService(uid: Utils.userId);
                  await _databaseService.deleteTask(widget.task.id);
                  Provider.of<HomeViewModel>(context, listen: false)
                      .updateTaskCount();
                  widget.refreshPage();
                },
                value: 1,
                child: Row(
                  children: [
                    IconWidget(icon: 'assets/delete.svg', height: 30),
                    const SizedBox(width: 12),
                    const Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Jost',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
