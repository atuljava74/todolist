import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/task.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('users');

  // Add a new task
  Future<DocumentReference<Map<String, dynamic>>> addTask(String title, String description) async {
    return await taskCollection.doc(uid).collection('tasks').add({
      'title': title,
      'description': description,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Mark a task as completed
  Future<void> updateTask(String taskId, bool isCompleted) async {
    return await taskCollection.doc(uid).collection('tasks').doc(taskId).update({
      'isCompleted': isCompleted,
    });
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    return await taskCollection.doc(uid).collection('tasks').doc(taskId).delete();
  }

  // Stream to get tasks
  Stream<List<Task>> get tasks {
    return taskCollection
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  // Convert Firestore snapshot to task list
  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Task(
        id: doc['id'],
        title: doc['title'],
        description: doc['description'],
        isCompleted: doc['isCompleted'],
        date: doc['createdAt'],
      );
    }).toList();
  }
}
