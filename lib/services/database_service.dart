import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:todolist/utils/constants.dart';

import '../model/task.dart';

class DatabaseService {
  final String uid; // The unique ID of the user
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Add a new task to the current user's task subcollection
  Future<DocumentReference<Map<String, dynamic>>> addTask(
      String title, String description, DateTime date) async {
    print("uid ${uid}");
    return await userCollection.doc(uid).collection('tasks').add({
      'title': title,
      'description': description,
      'isCompleted': false,
      'date':
          DateFormat('yyyy-MM-dd').format(date), // Store date as 'YYYY-MM-DD'
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update task completion status
  Future<void> updateTask(String taskId, bool isCompleted) async {
    return await userCollection
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({
      'isCompleted': isCompleted,
    });
  }

  // Update task information (title, description, and date)
  Future<void> updateTaskInfo(
      String taskId, String title, String description, DateTime date) async {
    return await userCollection
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({
      'title': title,
      'description': description,
      'date': DateFormat('yyyy-MM-dd')
          .format(date), // Ensure date is stored as 'YYYY-MM-DD'
    });
  }

  // Delete a task by its ID
  Future<void> deleteTask(String taskId) async {
    return await userCollection
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  // Stream to get tasks for the current user
  Stream<List<Task>> get tasks {
    return userCollection
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  // Convert Firestore snapshot into a list of Task objects
  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Task(
        id: doc.id, // Each task document ID is used for task identification
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        isCompleted: doc['isCompleted'] ?? false,
        date: DateFormat('yyyy-MM-dd').parse(
            doc['date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now())),
      );
    }).toList();
  }

  // Fetch tasks for the selected date using the 'YYYY-MM-DD' format
  Future<List<Task>> getTasksByDate(String date) async {
    QuerySnapshot snapshot = await userCollection
        .doc(uid)
        .collection('tasks')
        .where('date', isEqualTo: date)
        .get();

    return snapshot.docs.map((doc) {
      return Task(
        id: doc.id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        date: DateFormat('yyyy-MM-dd').parse(doc['date'] ??
            DateFormat('yyyy-MM-dd').format(DateTime.now())), // Parse date
        isCompleted: doc['isCompleted'] ?? false,
      );
    }).toList();
  }

  Future<int> getTaskCount() async {
    final String apiUrl = '$BASE_URL/getTaskCount?userId=$uid';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('data $data');
        return data['totalTasks'] ?? 0;
      } else {
        throw Exception('Failed to load task count');
      }
    } catch (e) {
      print('Error fetching task count: $e');
      return 0;
    }
  }

  updateTaskCount() async {
    final String apiUrl = '$BASE_URL/updateTaskCount?userId=$uid';
    try {
      await http.get(Uri.parse(apiUrl));
    } catch (e) {
      print('Error fetching task count: $e');
    }
  }
}
