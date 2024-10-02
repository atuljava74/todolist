import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:todolist/bottom_sheet/tag_category/tag_category.dart';
import 'package:todolist/bottom_sheet/task_priority/task_priority.dart';
import '../../home_screen/home_screen_viewmodel.dart';
import '../../pick_date/date.dart';
import '../../services/auth_service.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/custom_textfield.dart';
import '../main_bottom_bar.dart';
import 'edit_task_viewmodel.dart';

class EditTaskScreenPage extends StatefulWidget {
   String task;
   String description;
  final String date;
  final String time;
  String category;
  String flag;
  int taskId;

  EditTaskScreenPage({
    Key? key,
    required this.task,
    required this.description,
    required this.date,
    required this.time,
    required this.flag,
    required this.category,
    required this.taskId,
  }) : super(key: key);

  @override
  State<EditTaskScreenPage> createState() => _EditTaskScreenPageState();
}

class _EditTaskScreenPageState extends State<EditTaskScreenPage> {
  // late String selectedDate;
  // late String selectedTime;


  @override
  void initState() {
    super.initState();
    Provider.of<EditCardViewModel>(context,listen: false).selectedDate = widget.date;
    Provider.of<EditCardViewModel>(context,listen: false).selectedTime = widget.time;
  }

  late EditCardViewModel _viewModel;
  late HomeScreenViewModel homeScreenViewModel;
  String selectedCategory = "";


  @override
  Widget build(BuildContext context) {
    _viewModel =
        context.watch<EditCardViewModel>(); // Re-assign to listen to changes
    homeScreenViewModel = Provider.of<HomeScreenViewModel>(context, listen: false); // Access HomeScreenViewModel
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff1D1D1D),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Add your add action here
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff1D1D1D),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SvgPicture.asset("assets/refresh.svg", height: 25, width: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.transparent,
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 250, // Define the width as per your requirement
                      child: Text(
                        widget.task,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Jost',
                          color: Colors.white,
                        ),
                        softWrap: true, // Ensures the text wraps when it exceeds the width
                        overflow: TextOverflow.visible, // Controls how the overflow text is handled
                      ),
                    )

                  ],
                ),
                GestureDetector(
                  onTap: () => changeTaskAndDescription(context),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: SvgPicture.asset("assets/edit_task.svg", height: 25, width: 25),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Jost',
                  color: Color(0xffAFAFAF),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTaskDetailRow("Task Time:", 'Today At ${_viewModel.selectedTime}', "assets/timer.svg", onTap: () {
             // _viewModel.showDatePickerAndTime(context);
              CustomCalendar(context);
            }),
            const SizedBox(height: 40),
            selectCategory("Task Category:", widget.category),
            const SizedBox(height: 40),
            _buildTaskDetailRow("Task Priority:", widget.flag, "assets/flag.svg",
              onTap: () async {
                // Open the TaskPriorityPage
                final newPriority = await showDialog<int>(
                  context: context,
                  builder: (context) {
                    return TaskPriorityPage(
                      onSelect: (int index) {
                        Navigator.of(context).pop(index); // Return the selected index
                      },
                    );
                  },
                );

                if (newPriority != null) {
                  setState(() {
                    widget.flag = newPriority.toString(); // Update the state with the selected priority
                  });
                }
              },
            ),
            // const SizedBox(height: 40),
            // _buildTaskDetailRow("Add Sub Task", "Add Sub-Task", "assets/sub_task.svg"),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                _showDeleteTaskDialog(context);
              },
              child: const Row(
                children: [
                  Icon(Icons.delete, size: 22, color: Colors.red),
                  SizedBox(width: 10),
                  Text(
                    "Delete Task",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Jost',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: CustomButton(
          text: 'Edit Task',
          onPressed: () {
            _viewModel.refreshUI();
            AuthService.updateTask(
              context,
              widget.taskId.toString(),
              widget.task,
              widget.description,
              _viewModel.selectedDate,
              _viewModel.selectedTime,
              widget.category,
              int.parse(widget.flag).toString(),
            );
            Navigator.pop(context); // Close the page after updating
            print("call api");

          },
          buttonColor: const Color(0xff8687E7),
          borderRadius: 5,
        ),
      ),


    );
  }

  void _showDeleteTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
          ),
          title: const Center(
            child: Column(
              children: [
                Text(
                  "Delete Task",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Jost',
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Divider(color: Color(0xff979797)),
              ],
            ),
          ),
          content: Text(
            "Are you sure you want to delete this task?\n     Task Title: ${widget.task}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Jost',
              color: Colors.white,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Color(0xff8687E7),fontSize: 18),
                  ),
                ),
                CustomButton(
                  text: 'Delete',
                  onPressed: () {
                    AuthService.deleteTask(widget.taskId);
                    //_viewModel.deleteTask(context, widget.taskId);
                    Navigator.of(context).pop();
                    Get.to(() => MainBottomPage());
                    homeScreenViewModel.fetchTasks(homeScreenViewModel.userId);

                  },
                  buttonColor: const Color(0xff8687E7),
                  borderRadius: 5,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  CustomCalendar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 420,
            color: const Color(0xff363636),
            child: Container(
              height: 420,
              color: const Color(0xff363636),
              child: CustomCalendarView(
                onDateTimeSelected: (String formattedDate, String time) { // Change TimeOfDay to String
                  setState(() {
                    _viewModel.selectedDate = formattedDate; // already a String in DD-MM-YYYY format
                    _viewModel.selectedTime = time; // Now it's a formatted string (e.g., "12:30")
                  });
                },
              ),
            ),


          ),
        );
      },
    );
  }

  Widget selectCategory(String label, String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              SvgPicture.asset("assets/tag.svg", height: 25, width: 25),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Jost',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            // Open the TagCategoryDialog and wait for a result
            final selectedCategory = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (BuildContext context) {
                return TagCategoryDialog(
                  onCategorySelected: (selectedCategory) {
                    setState(() {
                      this.selectedCategory = selectedCategory; // Update the selected category
                    });
                  },
                );
              },
            );

            if (selectedCategory != null) {
              setState(() {
                widget.category = selectedCategory['label'];
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            height: 35,
            decoration: BoxDecoration(
              color: const Color(0xffAFAFAF),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '${widget.category}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskDetailRow(String label, String value, String iconPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, // Add onTap for the task detail row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(iconPath, height: 25, width: 25),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Jost',
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            height: 35,
            decoration: BoxDecoration(
              color: const Color(0xffAFAFAF),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Jost',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changeTaskAndDescription(BuildContext context) {
    final TextEditingController taskController = TextEditingController(text: widget.task);
    final TextEditingController descriptionController = TextEditingController(text: widget.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(5),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      "Edit Task",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Jost',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color(0xff979797)),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: taskController,
                    hintText: 'Task',
                    hintTextColor: Color(0xffAFAFAF),
                    borderColor: Colors.white,
                    textFieldColor: Colors.transparent,
                    borderRadius: 5,
                    borderWidth: 1,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                    hintTextColor: Color(0xffAFAFAF),
                    borderColor: Colors.white,
                    textFieldColor: Colors.transparent,
                    borderRadius: 5,
                    borderWidth: 1,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xff8687E7),fontSize: 18)),
                      ),
                      CustomButton(
                        text: 'Save',
                        onPressed: () {
                          // Assuming you want to save the changes
                          setState(() {
                            widget.task = taskController.text;
                            widget.description = descriptionController.text;
                          });
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        buttonColor: const Color(0xff8687E7),
                        borderRadius: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
