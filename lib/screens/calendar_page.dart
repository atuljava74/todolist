import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDay = DateTime.now();
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // To fetch tasks for the selected date
  Stream<QuerySnapshot> _getTasksForSelectedDate() {
    return _firestore
        .collection('tasks')
        .where('date', isEqualTo: _selectedDate)
        .snapshots();
  }

  // To get the start of the week from the selected date
  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // Generate 7 days list starting from the current start of the week
  List<DateTime> _getCurrentWeekDays() {
    DateTime startOfWeek = _getStartOfWeek(_selectedDay);
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  // Move to previous week
  void _goToPreviousWeek() {
    setState(() {
      _selectedDay = _selectedDay.subtract(Duration(days: 7));
      _selectedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
    });
  }

  // Move to next week
  void _goToNextWeek() {
    setState(() {
      _selectedDay = _selectedDay.add(Duration(days: 7));
      _selectedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
    });
  }
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDays = _getCurrentWeekDays();
    String monthYear = DateFormat('MMMM yyyy').format(_selectedDay); // Format the month and year

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text('Tasks for $_selectedDate',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: 'Jost',
          fontStyle: FontStyle.normal,
        ),
        ),
      ),
      body: Column(
        children: [
          // Month, Year and navigation buttons
          Container(
            //margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios,size: 18,),
                        onPressed: _goToPreviousWeek,
                      ),
                      Text(
                        monthYear,
                        style: const TextStyle(
                            fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Jost',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,size: 18,),
                        onPressed: _goToNextWeek,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weekDays.length,
                    itemBuilder: (context, index) {
                      final day = weekDays[index];
                      final isSelected = isSameDay(_selectedDay, day);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDay = day;
                            _selectedDate = DateFormat('yyyy-MM-dd').format(day);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            width: 55,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
                                  spreadRadius: 1, // Spread radius (controls the shadow size)
                                  blurRadius: 8, // Blur radius (controls the softness of the shadow)
                                  offset: Offset(0, 2), // Offset for shadow to appear evenly on all sides
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('EEE').format(day), // Day name (e.g., Mon)
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Jost',
                                    fontStyle: FontStyle.normal,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('dd').format(day), // Date (e.g., 12)
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Jost',
                                    fontStyle: FontStyle.normal,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: _getTasksForSelectedDate(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final tasks = snapshot.data!.docs;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                // Check if this card is the selected one
                bool isSelected = selectedIndex == index;

                return Card(
                  color: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(
                      color: isSelected ? Colors.green : Colors.transparent, // Highlight only selected card
                      width: 1, // Adjust border width
                    ),
                  ),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        setState(() {
                          // Update the selectedIndex to the current index when tapped
                          if (selectedIndex == index) {
                            selectedIndex = null; // Unselect if the same item is tapped again
                          } else {
                            selectedIndex = index;
                          }
                        });
                      },
                      child: isSelected
                          ? Image.asset("assets/correct.png",height: 30,width: 30,)
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
                      task['title'],
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
                          task['description'],
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
                            const SizedBox(width: 6),
                            Text(
                              _selectedDate,
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
                      icon: Icon(Icons.more_vert, size: 35, color: Colors.grey), // Three-dot icon
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {

                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset("assets/edit.png", height: 25, width: 25),
                                      const SizedBox(width: 15),
                                      const Text(
                                        "Edit",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Jost',
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () {
                                    FirebaseFirestore.instance.collection('tasks').doc(task.id).delete();
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset("assets/delete.png", height: 25, width: 25),
                                      const SizedBox(width: 15,),
                                      const Text(
                                        "Delete",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Jost',
                                          fontStyle: FontStyle.normal,
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
            );
          },
        ),
      ),
        ],
      ),
    );
  }
}

