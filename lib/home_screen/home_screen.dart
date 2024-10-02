import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todolist/model/get_task.dart';
import '../bottom_sheet/card/card.dart';
import '../bottom_sheet/edit_card/edit_task.dart';
import '../widgets/custom_textfield.dart';
import 'home_screen_viewmodel.dart';

class HomeScreenPage extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;

  HomeScreenPage({required this.tasks});

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  late HomeScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);
      _viewModel.searchTextController = TextEditingController();
      _viewModel.searchController.addListener(_filterTasks);
      _viewModel.fetchTasks(_viewModel.userId);
     _viewModel. initialize();
      _viewModel.refreshUI();
      //print("refresh home page");
    });
  }

  void _filterTasks() {
    String query = _viewModel.searchController.text.toLowerCase();
    setState(() {
      _viewModel.filteredTasks = widget.tasks.where((task) {
        return task['task']?.toString().toLowerCase().contains(query) ?? false;
      }).cast<GetTask>().toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    //print("home page is edit");
    _viewModel = context.watch<HomeScreenViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
           _viewModel.userName,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Jost',
              color: Colors.white,
            ),
          ),
        ),
         leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/app_icon.png'),
              radius: 18,
            ),
          ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            height: 25,width: 25,color: Colors.transparent,),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search TextField
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: CustomTextField(
                    controller: _viewModel.searchController,
                    hintText: 'Search for your task...',
                    hintTextColor: const Color(0xffAFAFAF),
                    borderRadius: 5,
                    borderColor: const Color(0xff979797),
                    textFieldColor: Colors.transparent,
                    prefixIcon: Icons.search,
                  ),
                ),
                const SizedBox(height: 14),
                // Today Button
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xff272727),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today",
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.white, size: 15),
                      ],
                    ),
                  ),
                ),
                // Task List
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _viewModel.tasks.length,
                  itemBuilder: (context, index) {
                    final task = _viewModel.tasks[index];

                    // Make sure to handle null properties
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: TaskCard(
                        task: task.title?.toString() ?? 'No Title',
                        description: task.description?.toString() ?? 'No Description', // Handle null
                        date: task.dateOfCompletion != null
                            ? task.dateOfCompletion!.toLocal().toString().split(' ')[0]
                            : 'N/A', // Format date
                        time: task.timeOfCompletion ?? 'N/A',
                        flag: task.priority ?? 'N/A',
                        category: task.taskCategory ?? 'General',
                        taskId: task.taskId ?? 0,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreenPage(
                                task: task.title?.toString() ?? 'No Title',
                                description: task.description?.toString() ?? 'No Description',
                                date: task.dateOfCompletion != null
                                    ? task.dateOfCompletion!.toLocal().toString().split(' ')[0]
                                    : 'N/A',
                                time: task.timeOfCompletion ?? 'N/A',
                                flag: task.priority ?? 'N/A',
                                category: task.taskCategory ?? 'General',
                                taskId: task.taskId ?? 0,
                              ),
                            ),
                          );
                          print("Back");
                          _viewModel.fetchTasks(_viewModel.userId);
                          // setState(() {
                          //
                          // });
                        },

                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Visibility(
              visible: _viewModel.showProgressbar,
              child: const Center(child: CircularProgressIndicator()))
        ],
      ),
    );
  }

  @override
  void dispose() {
   // _viewModel.searchController.dispose();
    super.dispose();
    print("dispose");
  }
}
