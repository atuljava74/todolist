import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/widgets/button_widget.dart';

class CustomCalendarView extends StatefulWidget {
  final Function(String, String) onDateTimeSelected; // Change TimeOfDay to String

  const CustomCalendarView({Key? key, required this.onDateTimeSelected}) : super(key: key);

  @override
  _CustomCalendarViewState createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;

  final List<String> _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff363636),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff363636),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousMonth,
          color: Colors.white,
        ),
        title: Center(
          child: Text(
            DateFormat('MMMM yyyy').format(_currentMonth),
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _nextMonth,
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weekDays.map((day) {
                bool isWeekend = day == 'Sun' || day == 'Sat'; // Check if the day is Sunday or Saturday
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isWeekend ? Colors.red : Colors.white, // Set color to red for weekends
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Jost',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.0),
              itemCount: _daysInMonth(_currentMonth),
              itemBuilder: (context, index) {
                DateTime date = DateTime(_currentMonth.year, _currentMonth.month, index + 1);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _selectedDate == date ? const Color(0xff8687E7) : Colors.grey[850],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: _selectedDate == date ? Colors.white : Colors.white70,
                          fontWeight: _selectedDate == date ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xff8687E7), fontSize: 18)),
                ),
                CustomButton(
                  text: 'Save',
                  onPressed: () {
                    if (_selectedDate != null) {
                      _showTimePicker(context);
                    }
                  },
                  buttonColor: const Color(0xff8687E7),
                  borderRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _daysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _showTimePicker(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && _selectedDate != null) {
      // Convert the selected date to YYYY-MM-DD format for database
      String formattedDatabaseDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      // Format TimeOfDay to HH:mm
      String formattedTime = pickedTime.hour.toString().padLeft(2, '0') + ':' + pickedTime.minute.toString().padLeft(2, '0');

      // Call the provided callback with the formatted database date and time
      widget.onDateTimeSelected(formattedDatabaseDate, formattedTime); // Pass formatted time
      Navigator.of(context).pop();
    }
  }


  // Dummy method for database insertion
  void insertDateIntoDatabase(String date) {
    // Your database insertion logic goes here
    print('Inserting date into database: $date'); // Example logging
  }
}
