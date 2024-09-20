import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist/widgets/icon_widget.dart';

import '../viewmodels/edit_task_vm.dart';

class EditTaskPage extends StatefulWidget {
  final String taskId;
  final String initialTitle;
  final String initialDescription;
  final DateTime initialDate;
  final String userId; // Add the userId to pass to the ViewModel
  final Function?
      refreshPageCallback; // Add the userId to pass to the ViewModel

  EditTaskPage({
    required this.taskId,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialDate,
    required this.userId, // Add userId parameter
    this.refreshPageCallback, // Add userId parameter
  });

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle;
    _description = widget.initialDescription;
    _selectedDate = widget.initialDate;
  }

  // Function to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditTaskViewModel(uid: widget.userId),
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
            'Edit Task',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Consumer<EditTaskViewModel>(
              builder: (context, editTaskViewModel, child) {
                return Column(
                  children: [
                    TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _title = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: _description,
                      decoration: InputDecoration(
                        labelText: 'Task Description',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _description = value;
                      },
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
                        'Task Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(height: 20),
                    Spacer(),
                    editTaskViewModel.isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                editTaskViewModel
                                    .updateTask(widget.taskId, _title,
                                        _description, _selectedDate)
                                    .then((_) {
                                  if (editTaskViewModel.errorMessage == null) {
                                    Navigator.pop(
                                        context); // Go back after successful edit
                                    if (widget.refreshPageCallback != null) {
                                      widget.refreshPageCallback!();
                                    }
                                  }
                                });
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
                              'Save Changes',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    editTaskViewModel.errorMessage != null
                        ? Text(
                            editTaskViewModel.errorMessage!,
                            style: TextStyle(color: Colors.red),
                          )
                        : Container(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
