import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../viewmodels/task_vm.dart';
import '../viewmodels/theme_vm.dart';
import 'login.dart';

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
          title: Text('Add Task'),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert), // Explicitly define the 3-dots icon
              onSelected: (value) async {
                if (value == 'theme') {
                  _showThemeToggleDialog(context);
                } else if (value == 'logout') {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()), // Redirect to login page
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'theme',
                  child: Row(
                    children: [
                      Icon(Icons.brightness_6),
                      SizedBox(width: 8),
                      Text('Change Theme'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
                    SizedBox(height: 20),
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
                            if (taskViewModel.errorMessage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Task added successfully!')),
                              );
                              Navigator.pop(context); // Close the add task page
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(taskViewModel.errorMessage!)),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: User not authenticated')),
                            );
                          }
                        }
                      },
                      child: Text('Add Task'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
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