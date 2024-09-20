import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/screens/add_task.dart';
import 'package:todolist/screens/home_page.dart';
import 'package:todolist/screens/login.dart';
import 'package:todolist/screens/signup.dart';
import 'package:todolist/viewmodels/calendar_vm.dart';
import 'package:todolist/viewmodels/home_vm.dart';
import 'package:todolist/viewmodels/login_vm.dart';
import 'package:todolist/viewmodels/signup_vm.dart';
import 'package:todolist/viewmodels/task_vm.dart';
import 'package:todolist/viewmodels/theme_vm.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(TodoListApp());
}

class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => CalendarViewModel()),
      ],
      child: MaterialApp(
        initialRoute: '/login',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: Color.fromRGBO(246, 246, 246, 1),
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/home': (context) => HomePage(),
          '/addtask': (context) => AddTaskPage()
        },
      ),
    );
  }
}
