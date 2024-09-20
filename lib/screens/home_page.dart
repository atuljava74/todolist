import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/viewmodels/home_vm.dart';
import 'package:todolist/widgets/icon_widget.dart';
import 'package:todolist/widgets/todo_list_widget.dart';

import '../model/task.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../viewmodels/theme_vm.dart';
import 'calendar_page.dart';
import 'edit_task.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel _homeViewModel;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    Provider.of<HomeViewModel>(context, listen: false).setUserName();
  }

  void _initializeUser() {
    User? user = FirebaseAuth
        .instance.currentUser; // Get the current user from FirebaseAuth
    if (user != null) {
      _databaseService = DatabaseService(
          uid: user.uid); // Initialize the DatabaseService with the user's uid
      Provider.of<HomeViewModel>(context, listen: false).setTotalTaskCount();
      Utils.userId = user.uid;
    }
  }

  Stream<List<Task>> _getTasksForToday() {
    return _databaseService.tasks; // Get the tasks for the current user
  }

  @override
  Widget build(BuildContext pageContext) {
    _homeViewModel = pageContext.watch<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello!',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              _homeViewModel.userName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 26,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: IconWidget(icon: 'assets/calendar.svg'),
            onPressed: () {
              Navigator.push(
                pageContext,
                MaterialPageRoute(
                    builder: (context) => CalendarPage(uid: Utils.userId)),
              );
            },
          ),
          // Three-dot icon for menu
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconWidget(
              icon: 'assets/logout.svg',
              onTap: () => _logout(),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Your total pending tasks ",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${_homeViewModel.totalTaskCount}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Task>>(
                stream: _getTasksForToday(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TodoListWidget(
                        task: task,
                        toggleTaskCompleted: () async {
                          await _databaseService.updateTask(
                            task.id,
                            !task.isCompleted,
                          );
                          setState(() {});
                        },
                        refreshPage: () => setState(() {}),
                        margin: EdgeInsets.symmetric(vertical: 8),
                      );
                      return Card(
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditTaskPage(
                                        taskId: task.id,
                                        initialTitle: task.title,
                                        initialDescription: task.description,
                                        initialDate: task.date,
                                        userId: Utils.userId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await _databaseService.deleteTask(task.id);
                                  Provider.of<HomeViewModel>(pageContext,
                                          listen: false)
                                      .updateTaskCount();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(pageContext, '/addtask');
        },
        child: Icon(Icons.add),
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

  // Handle logout
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Assuming you have a LoginPage
    );
  }
}
