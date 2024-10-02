import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For state management
import 'package:googleapis/connectors/v1.dart' as googleApis; // Aliasing the googleapis Provider
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For state management
import 'package:googleapis/connectors/v1.dart' as googleApis; // Aliasing the googleapis Provider
import '../bottom_sheet/card/card.dart';
import '../bottom_sheet/card/card_viewmodel.dart';
import '../bottom_sheet/edit_card/edit_task.dart';
import '../bottom_sheet/edit_card/edit_task_viewmodel.dart';
import '../bottom_sheet/table_calendar/table_calender.dart';
import '../home_screen/home_screen_viewmodel.dart';
import '../model/get_task.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';

class CalendarScreenPage extends StatefulWidget {
  const CalendarScreenPage({Key? key}) : super(key: key);

  @override
  State<CalendarScreenPage> createState() => _CalendarScreenPageState();
}

class _CalendarScreenPageState extends State<CalendarScreenPage> {
  late HomeScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
    // Fetch all tasks
    _viewModel.fetchTasks(_viewModel.userId); // Ensure this method fetches all tasks.
  }

  bool _isTodaySelected = true; // Default to Today
  bool _isCompleteSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Calendar',
      ),
      body: Column(
        children: [
          const TableCalendarView(), // Your calendar widget
          const SizedBox(height: 18),
          _buildButtonBar(), // Button bar for "Today" and "Complete"
          const SizedBox(height: 20),
          _buildTasks(), // Display tasks based on selection
        ],
      ),
    );
  }

  Widget _buildButtonBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff4C4C4C),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // "Today" Button
            Expanded(
              child: CustomButton(
                text: 'Today',
                onPressed: () {
                  setState(() {
                    _isTodaySelected = true;
                    _isCompleteSelected = false; // Deselect other button
                  });
                },
                borderRadius: 5,
                buttonColor: _isTodaySelected ? const Color(0xff8687E7) : Colors.transparent,
                borderColor: const Color(0xff979797),
              ),
            ),
            const SizedBox(width: 25), // Add space between buttons
            // "Complete" Button
            Expanded(
              child: CustomButton(
                text: 'Complete',
                onPressed: () {
                  setState(() {
                    _isCompleteSelected = true;
                    _isTodaySelected = false; // Deselect other button
                  });
                },
                borderRadius: 5,
                buttonColor: _isCompleteSelected ? const Color(0xff8687E7) : Colors.transparent,
                borderColor: const Color(0xff979797),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasks() {
    // Assuming _viewModel is already defined in your widget.
    print("Number of tasks: ${_viewModel.tasks.length}");

    // If the "Complete" button is selected, show completed tasks
    if (_isCompleteSelected) {
      // Filter completed tasks
      final completedTasks = _viewModel.tasks.where(
            (task) {
          final isCompleted = Provider.of<CardViewModel>(context, listen: false).isTaskCompleted(task.taskId);
          print("Task ID: ${task.taskId}, Is Completed: $isCompleted");
          return isCompleted;
        },
      ).toList();

      // Debugging: Print completed tasks
      print("Completed tasks: ${completedTasks.length}");
      for (var task in completedTasks) {
        print("Completed Task: ${task.title}");
      }

      // If no completed tasks are available
      if (completedTasks.isEmpty) {
        return const Center(child: Text('No completed tasks available'));
      }

      // Return completed tasks list in a light red container
      return Expanded(
        child: Container(
          color: Colors.black,
          child: ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return Container(
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: TaskCard(
                  task: task.title ?? 'No Title',
                  description: task.description ?? 'No Description',
                  date: task.dateOfCompletion != null
                      ? task.dateOfCompletion!.toLocal().toString().split(' ')[0]
                      : 'N/A',
                  time: task.timeOfCompletion ?? 'N/A',
                  flag: task.priority ?? 'N/A',
                  category: task.taskCategory ?? 'General',
                  taskId: task.taskId ?? 0,
                  onPressed: () {},
                ),
              );
            },
          ),
        ),
      );
    }

    // If no tasks are available, display a message
    if (_viewModel.tasks.isEmpty) {
      return const Center(
        child: Text('No tasks available'),
      );
    }

    // Show all tasks if "Complete" button is not selected
    return Expanded(
      child: ListView.builder(
        itemCount: _viewModel.tasks.length,
        itemBuilder: (context, index) {
          final task = _viewModel.tasks[index];
          return Container(
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: TaskCard(
              task: task.title ?? 'No Title',
              description: task.description ?? 'No Description',
              date: task.dateOfCompletion != null
                  ? task.dateOfCompletion!.toLocal().toString().split(' ')[0]
                  : 'N/A',
              time: task.timeOfCompletion ?? 'N/A',
              flag: task.priority ?? 'N/A',
              category: task.taskCategory ?? 'General',
              taskId: task.taskId ?? 0,
              onPressed: () {
                // Define what happens when "Edit" is pressed
              },
            ),
          );
        },
      ),
    );
  }





}



// // Today Content Widget
// class TodayContent extends StatelessWidget {
//   final String task;
//   final String description;
//   final String date;
//   final String time;
//   final String flag;
//   final String category;
//   final int taskId;
//
//   TodayContent({
//     Key? key,
//     required this.task,
//     required this.description,
//     required this.date,
//     required this.time,
//     required this.flag,
//     required this.category,
//     required this.taskId,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: Card(
//         color: const Color(0xff272727),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Stack(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 15,
//                     width: 15,
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.circular(50),
//                       border: Border.all(
//                         width: 1,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           task,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontFamily: 'Jost',
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Today At $time',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                             fontFamily: 'Jost',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Positioned(
//                 right: 0,
//                 bottom: 35,
//                 child: IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.white, size: 16),
//                   onPressed: () {
//                     // Navigate to EditTaskPage with the current task details
//                   },
//                 ),
//               ),
//               Positioned(
//                 right: 0,
//                 bottom: 0,
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         print("Category clicked: $category");
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xff809CFF),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(5),
//                           child: Center(
//                             child: Row(
//                               children: [
//                                 Icon(Icons.category, color: const Color(0xff0055A3), size: 14),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   category,
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: 'Jost',
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Container(
//                       width: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.transparent,
//                         borderRadius: BorderRadius.circular(5),
//                         border: Border.all(
//                           width: 1,
//                           color: const Color(0xff8687E7),
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(5),
//                         child: Center(
//                           child: Row(
//                             children: [
//                               Icon(Icons.flag, color: Colors.white, size: 14),
//                               const SizedBox(width: 8),
//                               Text(
//                                 flag,
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w300,
//                                   fontFamily: 'Jost',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Complete Content Widget
class CompleteContent extends StatelessWidget {
  const CompleteContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Text(
        'Completed tasks or events will be displayed here!',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
