import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../viewmodels/theme_vm.dart';
import 'calendar_page.dart';
import 'edit_task.dart';
import 'login.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> _usernameFuture;

  // Fetch the username from Firestore
  Future<String?> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc['username'];
    }
    return null;
  }

  late DatabaseService _databaseService;
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _usernameFuture = _getUsername();

  }

  // Initialize the user and DatabaseService
  void _initializeUser() {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user from FirebaseAuth
    if (user != null) {
      _databaseService = DatabaseService(uid: user.uid); // Initialize the DatabaseService with the user's uid
    }
  }

  // Fetch today's tasks for the logged-in user
  Stream<List<Task>> _getTasksForToday() {
    return _databaseService.tasks; // Get the tasks for the current user
  }

  // Count total tasks for today (if needed)
  Future<int> _getTaskCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('tasks')
        .get();
    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: FutureBuilder<String?>(
          future: _usernameFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('TodoList');
            } else if (snapshot.hasError || snapshot.data == null) {
              return Text('TodoList');
            } else {
              return Text('Hi, ${snapshot.data!}');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );
            },
          ),
          // Three-dot icon for menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'theme') {
                _showThemeToggleDialog(context);
              } else if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
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
              ];
            },
          ),
        ],
      ),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 10,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff053262),
                  Color(0xff053262),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          FutureBuilder<int>(
            future: _getTaskCount(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return Text(
                  'Total tasks today: ${snapshot.data}',
                  style: TextStyle(fontSize: 22),
                );
              }
            },
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
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _databaseService.deleteTask(task.id);
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
          Navigator.pushNamed(context, '/addtask');
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
      MaterialPageRoute(builder: (context) => LoginPage()), // Assuming you have a LoginPage
    );
  }
}
