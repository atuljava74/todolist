import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'card_viewmodel.dart'; // Adjust the import path as needed

class TaskCard extends StatefulWidget {
  final String task;
  final String description;
  final String date;
  final String time;
  final String flag;
  final String category;
  int taskId;
  final VoidCallback onPressed;

  TaskCard({
    Key? key,
    required this.task,
    required this.description,
    required this.date,
    required this.time,
    required this.flag,
    required this.category,
    required this.taskId,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  //late HomeScreenViewModel homeScreenViewModel;
  @override
  Widget build(BuildContext context) {
    final _viewModel = context.watch<CardViewModel>();
    final isCompleted = _viewModel.isTaskCompleted(widget.taskId);
    final isLoading = _viewModel.isLoading;
    //homeScreenViewModel = Provider.of<HomeScreenViewModel>(context, listen: false); // Access HomeScreenViewModel

    return Opacity(
      opacity: isCompleted ? 0.5 : 1,
      child: Container(
        width: double.infinity,
        child: Card(
          color: const Color(0xff272727),
          shape: RoundedRectangleBorder(
            side: isCompleted
                ? const BorderSide(color: Colors.green, width: 2)
                : const BorderSide(color: Colors.transparent, width: 0),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: isCompleted || isLoading
                          ? null
                          : () async {
                        // Mark task as completed
                        await _viewModel.markTaskAsComplete(widget.taskId);
                      //  homeScreenViewModel.fetchTasks(homeScreenViewModel.userId);
                        print("complete task");
                      },
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.green
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          ),
                        ),
                        child: isCompleted
                            ? const Icon(Icons.check, size: 10, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.task,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Today At ${widget.time}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: 35,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                    onPressed: isCompleted ? null : widget.onPressed,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Category clicked: ${widget.category}");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff809CFF),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Center(
                              child: Row(
                                children: [
                                  const Icon(Icons.category,
                                      color: Color(0xff0055A3), size: 14),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.category,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Jost',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xff8687E7),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Row(
                              children: [
                                const Icon(Icons.flag, color: Colors.white, size: 14),
                                const SizedBox(width: 8),
                                Text(
                                  widget.flag,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Jost',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
