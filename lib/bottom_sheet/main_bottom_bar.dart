import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../calendar_page/calendar_page.dart';
import '../home_screen/home_screen.dart';
import '../profile/profile_page.dart';
import '../services/auth_service.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/snackbar.dart';
import 'bottom_sheet/bottom_sheet.dart';
import '../model/get_task.dart';  // Ensure the GetTask model is imported

class MainBottomPage extends StatefulWidget {
  @override
  _MainBottomPageState createState() => _MainBottomPageState();
}

class _MainBottomPageState extends State<MainBottomPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  List<GetTask> tasks = [];  // Now using a List<GetTask>

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);  // Switch page
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      backgroundColor: const Color(0xff363636),
      context: context,
      builder: (context) {
        return AddTaskBottomSheet(
          onSave: (task, description, date, time, flag, category) {
            if (task.isNotEmpty && description.isNotEmpty && date.isNotEmpty && time.isNotEmpty && flag != null && category.isNotEmpty) {
              setState(() {
                // Generate a unique taskId as an int
                int taskId = DateTime.now().millisecondsSinceEpoch;

                // Create an instance of GetTask and add it to the tasks list
                tasks.add(GetTask(
                  taskId: taskId,  // Assign the generated int taskId
                  title: task,
                  description: description,
                  dateOfCompletion: DateTime.parse(date),  // Assuming date is in 'yyyy-MM-dd' format
                  timeOfCompletion: time,
                  priority: flag.toString(),
                  taskCategory: category,
                ));
              });
              AuthService.addTask(); // Assuming this is where you save the task
              CustomSnackBar.showSnackBar("Task added successfully");
              // Fluttertoast.showToast(
              //   msg: "Task added successfully",
              //   toastLength: Toast.LENGTH_LONG,
              //   gravity: ToastGravity.BOTTOM,
              //   timeInSecForIosWeb: 2,
              //   backgroundColor: Colors.black,
              //   textColor: Colors.white,
              //   fontSize: 16.0,
              // );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields.')));
            }
          },
        );
      },
    );
  }


  List<Map<String, dynamic>> _convertTasksToMapList() {
    // Convert the List<GetTask> to List<Map<String, dynamic>>
    return tasks.map((task) {
      return {
        'taskId': task.taskId,
        'title': task.title,
        'description': task.description,
        'dateOfCompletion': task.dateOfCompletion,
        'timeOfCompletion': task.timeOfCompletion,
        'priority': task.priority,
        'taskCategory': task.taskCategory,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomeScreenPage(tasks: _convertTasksToMapList()),  // Convert tasks to List<Map<String, dynamic>>
          CalendarScreenPage(),  // Pass List<GetTask> directly to CalendarScreenPage
          const Center(
            child: Text(
              'Focus Page',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          ProfilePage(),  // Ensure ProfilePage is correctly implemented
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskBottomSheet,
        backgroundColor: const Color(0xff8687E7),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(onTabTapped: _onTabTapped),  // Ensure BottomBar is correctly implemented
    );
  }
}
