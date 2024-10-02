import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todolist/bottom_sheet/task_priority/task_priority_viewmodel.dart';

import '../../widgets/button_widget.dart';

class TaskPriorityPage extends StatefulWidget {
  final Function(int) onSelect;

  TaskPriorityPage({Key? key, required this.onSelect}) : super(key: key);

  @override
  _TaskPriorityPageState createState() => _TaskPriorityPageState();
}

class _TaskPriorityPageState extends State<TaskPriorityPage> {
  late TaskPriorityViewModel _viewModel;


  Widget buildPriorityContainer(int index) {
    _viewModel = context.watch<TaskPriorityViewModel>();
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewModel.selectedIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 45,
            decoration: BoxDecoration(
              color: _viewModel.selectedIndex == index ? const Color(0xff8687E7) : const Color(0xff272727),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/flag.svg",
                height: 20,
                width: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            (index + 1).toString(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'Jost',
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xff363636),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: const Center(
        child: Column(
          children: [
             Text(
              'Task Priority',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Jost',
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Divider(color: Color(0xff979797)),
          ],
        ),
      ),
      content: Container(
        height: 250,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: buildPriorityContainer(0),
                ),
                Expanded(
                  child: buildPriorityContainer(1),
                ),
                Expanded(
                  child: buildPriorityContainer(2),
                ),
                Expanded(
                  child: buildPriorityContainer(3),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Second Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: buildPriorityContainer(4),
                ),
                Expanded(
                  child: buildPriorityContainer(5),
                ),
                Expanded(
                  child: buildPriorityContainer(6),
                ),
                Expanded(
                  child: buildPriorityContainer(7),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Third Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: buildPriorityContainer(8),
                ),
                Expanded(
                  child: buildPriorityContainer(9),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Color(0xff8687E7),fontSize: 18)),
            ),
            Container(
              child: CustomButton(
                text: 'Save',
                onPressed: () {
                  if (_viewModel.selectedIndex != null) {
                    // Add 1 to the selected index to match priority selection
                    int selectedPriority = _viewModel.selectedIndex! + 1;

                    widget.onSelect(selectedPriority); // Pass the correct priority to the parent
                    print("Selected priority: $selectedPriority");

                    // Perform other actions like closing the dialog
                    // Navigator.of(context).pop(); // Close the dialog
                    print("Selected complete");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a priority.')),
                    );
                  }
                },
                borderRadius: 5,
                buttonColor: const Color(0xff8687E7),
                buttonHeight: 50,
                buttonWidth: 80,
              ),
            ),

          ],
        ),
      ],
    );
  }
}
