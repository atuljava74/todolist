import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLoginInfo(String email, String password, String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('user_name', userName); // Save the username
  }




  // static Future<void> saveLoginInfo(String email, String password, String userName) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('email', email);
  //   await prefs.setString('password', password);
  //   await prefs.setString('userName', userName); // Save the username
  // }
  //
  // static Future<String?> getUserName() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('userName'); // Retrieve the username
  // }

  static Future<Map<String, String?>> getLoginInfo() async {
    String? email = _prefs?.getString('email');
    String? password = _prefs?.getString('password');
    return {'email': email, 'password': password};
  }

  static Future<void> clearLoginInfo() async {
    await _prefs?.remove('email');
    await _prefs?.remove('password');
  }

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('user_id'); // Retrieve as String
    return userIdString != null ? int.tryParse(userIdString) : null; // Convert to int
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name'); // Retrieve the username
  }

  static Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    String categoriesJson = jsonEncode(categories);
    print('Saving categories JSON: $categoriesJson');
    await _prefs?.setString('categories', categoriesJson);
    print("Save Category is done");
  }

  static Future<List<Map<String, dynamic>>> loadCategories() async {
    print("loadCategories");
    final String? categoriesString = _prefs?.getString('categories');
    print('Loaded category string: $categoriesString');
    if (categoriesString != null && categoriesString.isNotEmpty) {
      print("Categories found, loading.");
      return List<Map<String, dynamic>>.from(jsonDecode(categoriesString));
    } else {
      print("No categories found, initializing default categories.");
      // Return an empty list or provide default categories
      return [];
    }
  }
}
