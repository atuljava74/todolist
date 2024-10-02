import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/constants.dart';
import 'package:get/get.dart'; // Import GetX

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey2 = GlobalKey<FormState>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> registerUser(BuildContext context) async {
    final String name = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    //if (!formKey2.currentState!.validate()) return;

    setLoading(true); // Show progress bar

    try {
      // Construct the data
      final response = await http.post(
          Uri.parse('$BASE_url/signup.php'),
          //headers: {"Content-Type": "application/json"},
          body: {
            'name': name,
            'email': email,
            'password': password,
          }
      );

      setLoading(false); // Hide progress bar when response is received

      // Handle the response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        print(jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }));

        if (responseData.containsKey('message')) {
          _showDialog(context, 'Success', responseData['message']);
        } else if (responseData.containsKey('error')) {
          _showDialog(context, 'Error', responseData['error']);
        }
      } else {
        _showDialog(context, 'Error', 'Server error: ${response.statusCode}');
      }
    } catch (error) {
      setLoading(false);
      _showDialog(context, 'Error', 'Error: $error');
      print("catch");
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (title == 'Success') {
                  Get.back(); // Navigate back using GetX
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void refreshUI() {
    notifyListeners();
  }
}
