import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/widgets/todo_list_widget.dart';

import '../model/task.dart';
import '../viewmodels/calendar_vm.dart';

class CalendarPage extends StatefulWidget {
  final String uid;

  const CalendarPage({required this.uid});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    // Fetch tasks when page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CalendarViewModel>(context, listen: false)
          .fetchTasksForSelectedDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarViewModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Consumer<CalendarViewModel>(
            builder: (context, calendarViewModel, child) {
              return Text(
                'Tasks for ${calendarViewModel.selectedDate}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Jost',
                  fontStyle: FontStyle.normal,
                ),
              );
            },
          ),
        ),
        body: Column(
          children: [
            Consumer<CalendarViewModel>(
              builder: (context, calendarViewModel, child) {
                String monthYear = DateFormat('MMMM yyyy')
                    .format(calendarViewModel.selectedDay);
                List<DateTime> weekDays =
                    calendarViewModel.getCurrentWeekDays();

                return TableCalendar(
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Colors.black,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  availableCalendarFormats: const {
                    CalendarFormat.month: '',
                    CalendarFormat.twoWeeks: '',
                    CalendarFormat.week: '',
                  },
                  headerStyle: const HeaderStyle(
                    titleTextStyle: TextStyle(fontSize: 30.0),
                    headerMargin:
                        EdgeInsets.only(left: 25.0, top: 0, bottom: 10),
                    leftChevronVisible: true,
                    rightChevronVisible: true,
                    formatButtonVisible: false,
                  ),
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2050, 12, 31),
                  focusedDay: calendarViewModel.focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(day, calendarViewModel.selectedDay);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      calendarViewModel.selectedDay = selectedDay;
                      calendarViewModel.focusedDay = selectedDay;
                      calendarViewModel.changeSelectedDay(selectedDay);
                      calendarViewModel.fetchTasksForSelectedDate();
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      calendarViewModel.focusedDay = focusedDay;
                    });
                  },
                );
              },
            ),
            Expanded(
              child: Consumer<CalendarViewModel>(
                builder: (context, calendarViewModel, child) {
                  if (calendarViewModel.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: calendarViewModel.tasks.length,
                          itemBuilder: (context, index) {
                            Task task = calendarViewModel.tasks[index];
                            return TodoListWidget(
                              task: task,
                              refreshPage: () => Provider.of<CalendarViewModel>(
                                      context,
                                      listen: false)
                                  .fetchTasksForSelectedDate(),
                              toggleTaskCompleted: () =>
                                  Provider.of<CalendarViewModel>(
                                context,
                                listen: false,
                              ).toggleTaskSelection(task),
                            );
                            return Card(
                              color: Colors.white,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide(
                                  color: task.isCompleted
                                      ? Colors.green
                                      : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    calendarViewModel.toggleTaskSelection(task);
                                  },
                                  child: task.isCompleted
                                      ? Image.asset("assets/correct.png",
                                          height: 30, width: 30)
                                      : Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                ),
                                title: Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Jost',
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.description,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff7D7D7D),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Jost',
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/timer.png",
                                          height: 12,
                                          width: 12,
                                          color: const Color(0xff888888),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          calendarViewModel.selectedDate,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xff888888),
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Jost',
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert,
                                      size: 35, color: Colors.grey),
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset("assets/edit.png",
                                                      height: 25, width: 25),
                                                  SizedBox(width: 15),
                                                  const Text(
                                                    "Edit",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Jost',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            InkWell(
                                              onTap: () {
                                                calendarViewModel
                                                    .deleteTask(task.id);
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                      "assets/delete.png",
                                                      height: 25,
                                                      width: 25),
                                                  SizedBox(width: 15),
                                                  const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Jost',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
