import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> signup(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      User? user = await _authService.signUp(email, password);
      if (user != null) {
        // Handle successful signup (you can add more logic here if needed)
      } else {
        _setErrorMessage('Signup failed. Please try again.');
      }
    } catch (e) {
      _setErrorMessage('An error occurred: ${e.toString()}');
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
