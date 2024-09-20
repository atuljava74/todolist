import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist/viewmodels/home_vm.dart';
import 'package:todolist/widgets/icon_widget.dart';

import '../viewmodels/task_vm.dart';
import '../viewmodels/theme_vm.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel(),
      child: Scaffold(
        appBar: AppBar(
          leading: Center(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: IconWidget(
                height: 25,
                icon: Icon(Icons.arrow_back, size: 17),
                showBorder: true,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Add Task',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
        ),
        body: Consumer<TaskViewModel>(
          builder: (context, taskViewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Task Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      title: Text(
                        'Task Date: ${DateFormat('yyyy-MM-dd').format(taskViewModel.selectedDate)}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () => taskViewModel.selectDate(context),
                    ),
                    Spacer(),
                    taskViewModel.isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                User? user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  await taskViewModel.addTask(
                                    user.uid,
                                    _titleController.text,
                                    _descriptionController.text,
                                  );
                                  Provider.of<HomeViewModel>(context,
                                          listen: false)
                                      .updateTaskCount();
                                  if (taskViewModel.errorMessage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Task added successfully!')),
                                    );
                                    Navigator.pop(
                                        context); // Close the add task page
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              taskViewModel.errorMessage!)),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Error: User not authenticated')),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff861C5B),
                              minimumSize: Size(
                                  double.infinity, 50), // Full-width button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Add Task',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Show theme toggle dialog
  void _showThemeToggleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Theme'),
          content: Consumer<ThemeViewModel>(
            builder: (context, themeViewModel, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dark Mode'),
                  Switch(
                    value: themeViewModel.isDarkTheme,
                    onChanged: (value) {
                      themeViewModel.toggleTheme();
                      Navigator.pop(context); // Close the dialog after toggling
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
