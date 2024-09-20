import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task.dart';

class DatabaseService {
  final String uid; // The unique ID of the user
  DatabaseService({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // Add a new task to the current user's task subcollection
  Future<DocumentReference<Map<String, dynamic>>> addTask(String title, String description, DateTime date) async {
    print("uid ${uid}");
    return await userCollection.doc(uid).collection('tasks').add({
      'title': title,
      'description': description,
      'isCompleted': false,
      'date': date.toIso8601String(), // Store date as string for consistency
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update task completion status
  Future<void> updateTask(String taskId, bool isCompleted) async {
    return await userCollection.doc(uid).collection('tasks').doc(taskId).update({
      'isCompleted': isCompleted,
    });
  }

  // Delete a task by its ID
  Future<void> deleteTask(String taskId) async {
    return await userCollection.doc(uid).collection('tasks').doc(taskId).delete();
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
        date: DateTime.parse(doc['date'] ?? DateTime.now().toIso8601String()),
      );
    }).toList();
  }
}
