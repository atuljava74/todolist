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

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDays = _getCurrentWeekDays();
    String monthYear = DateFormat('MMMM yyyy').format(_selectedDay); // Format the month and year

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks for $_selectedDate'),
      ),
      body: Column(
        children: [
          // Month, Year and navigation buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _goToPreviousWeek,
                ),
                Text(
                  monthYear,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _goToNextWeek,
                ),
              ],
            ),
          ),
          // Horizontal scrollable dates for the current week
          Container(
            height: 60,
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
                  child: Container(
                    width: 80,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(day), // Day name (e.g., Mon)
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat('dd').format(day), // Date (e.g., 12)
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                    return Card(
                      child: ListTile(
                        title: Text(task['title']),
                        subtitle: Text(task['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Handle task edit logic
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _firestore
                                    .collection('tasks')
                                    .doc(task.id)
                                    .delete();
                              },
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
