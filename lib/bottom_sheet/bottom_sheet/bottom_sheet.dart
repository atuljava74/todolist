import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todolist/bottom_sheet/tag_category/tag_category.dart';
import 'package:todolist/bottom_sheet/task_priority/task_priority.dart';
import '../../home_screen/home_screen_viewmodel.dart';
import '../../pick_date/date.dart';
import '../../widgets/custom_textfield.dart';
import '../card/card.dart';
import 'bottom_sheet_viewmodel.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Function(String, String, String, String, int,String) onSave;

  AddTaskBottomSheet({Key? key, required this.onSave}) : super(key: key);

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  late BottomSheetViewModel _viewModel;
  late HomeScreenViewModel homeScreenViewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<BottomSheetViewModel>();
    homeScreenViewModel = Provider.of<HomeScreenViewModel>(context, listen: false); // Access HomeScreenViewModel
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Task",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Jost',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _viewModel.addTaskController,
            hintText: 'Add Task',
            hintTextColor: const Color(0xffAFAFAF),
            borderRadius: 5,
            borderColor: Colors.white,
            textFieldColor: Colors.transparent,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _viewModel.descriptionController,
            hintText: 'Add Description',
            hintTextColor: const Color(0xffAFAFAF),
            borderRadius: 5,
            borderColor: Colors.white,
            textFieldColor: Colors.transparent,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
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
                    },
                    child: SvgPicture.asset("assets/timer.svg", height: 30, width: 30),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _viewModel.showTagDialog(context),
                    child: SvgPicture.asset("assets/tag.svg", height: 30, width: 30),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _viewModel.showNumberDialog(context),
                    child: SvgPicture.asset("assets/flag.svg", height: 30, width: 30),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (_viewModel.addTaskController.text.isNotEmpty &&
                      _viewModel.descriptionController.text.isNotEmpty &&
                      _viewModel.selectedDate.isNotEmpty &&
                      _viewModel.selectedTime.isNotEmpty &&
                      _viewModel.selectedCategory.isNotEmpty &&
                      _viewModel.selectedFlag != null) {
                    _viewModel.addTask(context).then((_) {
                      // Call the onSave function with the task data
                      widget.onSave(
                        _viewModel.addTaskController.text,
                        _viewModel.descriptionController.text,
                        _viewModel.selectedDate,
                        _viewModel.selectedTime,
                        _viewModel.selectedFlag!,
                        _viewModel.selectedCategory,
                      );
                      // Reset all controllers and selected values
                      _viewModel.addTaskController.clear();
                      _viewModel.descriptionController.clear();
                      _viewModel.selectedDate = ''; // Assuming selectedDate is a String
                      _viewModel.selectedTime = ''; // Assuming selectedTime is a String
                      _viewModel.selectedCategory = ''; // Assuming selectedCategory is a String
                      _viewModel.selectedFlag = null; // Resetting flag
                      homeScreenViewModel.fetchTasks(homeScreenViewModel.userId);

                      Navigator.pop(context); // Close the bottom sheet
                    });
                  }
                },
                child: SvgPicture.asset("assets/send.svg", height: 30, width: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
