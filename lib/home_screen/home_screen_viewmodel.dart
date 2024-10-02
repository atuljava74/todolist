import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/services/auth_service.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode
import '../constants.dart';
import '../model/get_task.dart';
import '../utils/sp_helper.dart';

class HomeScreenViewModel extends ChangeNotifier {
  List<GetTask> tasks = [];
  final TextEditingController searchController = TextEditingController();
  late TextEditingController searchTextController = TextEditingController();
  List<GetTask> filteredTasks = [];
  bool showProgressbar = false;
  int userId = 0; // Replace this with the actual user ID you want to use
  int selectedTaskId = 0;
  String userName = "";

  void selectTaskId(int? id) {
    selectedTaskId = id!;
    notifyListeners();
  }


  Future<void> initialize() async {
    userId = await SharedPreferencesHelper.getUserId() ?? 0; // Fetch user ID from SharedPreferences
    userName = await SharedPreferencesHelper.getUserName() ?? "Task List";
    if (userId != 0) {
      await fetchTasks(userId); // Fetch tasks only if userId is valid
    }
  }

  Future<void> fetchTasks(int userId) async {
    showProgressbar = true;
    final url = '$BASE_url/get_task.php?user_id=$userId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          tasks = jsonResponse.map((taskJson) => GetTask.fromJson(taskJson)).toList();
        } else {
          print("Unexpected response format: $jsonResponse");
        }
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching tasks: $error");
    } finally {
      showProgressbar = false;
      notifyListeners(); // Notify listeners to refresh UI
    }
  }

  setLoading(bool loading) {
    showProgressbar = loading;
    notifyListeners();
  }


  refreshUI() {
    notifyListeners();
  }
}
