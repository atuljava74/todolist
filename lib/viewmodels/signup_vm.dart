import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<void> signup(String email, String password, String username) async {
    isLoading = true;
    notifyListeners();
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save the username and other user info in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'username': username, // Save the username
        'createdAt': FieldValue.serverTimestamp(),
      });

      errorMessage = null;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
    isLoading = false;
    notifyListeners();
  }
}
