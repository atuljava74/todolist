import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';

class HomeViewModel extends ChangeNotifier {
  int totalTaskCount = 0;
  String userName = "";

  setUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        userName = userData?['username'] ?? "";
        notifyListeners();
      }
    } catch (e) {}
  }

  Future<void> setTotalTaskCount() async {
    User? user = FirebaseAuth.instance.currentUser;
    DatabaseService databaseService = DatabaseService(uid: user!.uid);
    totalTaskCount = await databaseService.getTaskCount();
    notifyListeners();
  }

  Future<void> updateTaskCount() async {
    User? user = FirebaseAuth.instance.currentUser;
    DatabaseService databaseService = DatabaseService(uid: user!.uid);
    await databaseService.updateTaskCount();
    setTotalTaskCount();
  }
}
