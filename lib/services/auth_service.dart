import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Add this import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/get_task.dart';
import '../utils/constants.dart';
import '../utils/sp_helper.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign-up function
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Login function
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Logout function
  Future<void> logout() async {
    await _auth.signOut();
  }

  static Future<Map<String, dynamic>> loginGet(String email, String password) async {
    try {
      // Prepare the request body
      final body = {
        'email': email,
        'password': password,
      };

      // Send a POST request to your API
      final response = await http.post(
        Uri.parse('$BASE_url/login.php'),
        body: body,
      );

      // Check the response status
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if login is successful
        if (data['message'] == 'Login successful') {
          return {
            'result': 1,
            'user_id': data['user_id'], // Return user_id on success
            'name': data['name'], // Return name on success
          };
        } else if (data['error'] == 'Invalid credentials') {
          return {'result': -1}; // Invalid credentials
        }
      }
      return {'result': 0}; // User not found or another issue
    } catch (e) {
      print('Login Error: $e');
      return {'result': 0}; // Failure case
    }
  }


  static Future<int> addTask() async {
    try {
      // Prepare the request body
      final body = {
        'user_id': "1",
        'title': "Testing",
        'description': "Testing",
        'date_of_completion': "12-12-2024",
        'time_of_completion': "1:10 PM",
        'task_category': "Urgent",
        'priority': "8",
      };

      // Send a POST request to your API
      final response = await http.post(
        Uri.parse('$BASE_url/add_task.php'),
        body: body,
      );

      // Check the response status
      if (response.statusCode == 200) {
        print("Task created");
      }
      return 0; // User not found or another issue
    } catch (e) {
      print('Login Error: $e');
      return 0; // Failure case
    }
  }

  static Future<void> deleteTask(int taskId) async {
    final response = await http.post(
      Uri.parse('$BASE_url/delete_task.php'),
      body: {
        'task_id': taskId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['error'] == null) {
        // Handle success, maybe show a Snackbar or update UI
       // CustomSnackBar.showSnackBar("Task added successfully");
        Fluttertoast.showToast(
          msg: "Task Deleted successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print(responseData['message']);
        // No need to notify listeners here
      } else {
        // Handle error
        print(responseData['error']);
      }
    } else {
      // Handle server errors
      print('Server error: ${response.statusCode}');
    }
  }

 static  Future<void> updateTask(
      BuildContext context,
      String taskId,
      String title,
      String description,
      String date,
      String time,
      String category,
      String priority,
      ) async {
    // Build the request body
    final body = {
      'task_id': taskId,
      'user_id': '1', // Assuming user_id is constant for now
      'title': title,
      'description': description,
      'date_of_completion': date,
      'time_of_completion': time,
      'task_category': category,
      'priority': priority.toString(),
    };

    print(body);

    bool toastShown = false; // Flag to prevent multiple toast messages

    try {
      // Send the POST request with the body data
      final response = await http.post(
        Uri.parse('$BASE_url/edit_task.php'),
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData); // Debug response

        if (responseData['error'] == null && !toastShown) {
          // Task was successfully updated, show a success snackbar
          Fluttertoast.showToast(
            msg: "Task updated successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          toastShown = true; // Set flag to true after showing toast

          Navigator.pop(context, true);
        } else if (!toastShown) {
          // Show error message from response
          Fluttertoast.showToast(
            msg: "Failed to update task",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          toastShown = true;
        }
      } else {
        //_showErrorDialog(context, 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      // _showErrorDialog(context, 'Network error: $e');
      print('Network error: $e');
    }
    // refreshUI();
  }

}
