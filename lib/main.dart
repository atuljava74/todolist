import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:provider/provider.dart';
import 'package:todolist/profile/profile_viewmodel.dart';
import 'package:todolist/register/register_page.dart';
import 'package:todolist/register/register_viewmodel.dart';
import 'package:todolist/splash_screen/splash_screen.dart';
import 'package:todolist/start_screen/start_screen_page.dart';
import 'package:todolist/start_screen/start_screen_viewmodel.dart';
import 'bottom_sheet/bottom_sheet/bottom_sheet_viewmodel.dart';
import 'bottom_sheet/card/card_viewmodel.dart';
import 'bottom_sheet/create_category/create_category_viewmodel.dart';
import 'bottom_sheet/edit_card/edit_task_viewmodel.dart';
import 'bottom_sheet/main_bottom_bar.dart';
import 'bottom_sheet/table_calendar/table_calendar_viewmodel.dart';
import 'bottom_sheet/tag_category/tag_category_viewmodel.dart';
import 'bottom_sheet/task_priority/task_priority_viewmodel.dart';
import 'firebase_options.dart';
import 'home_screen/home_screen_viewmodel.dart';
import 'intro/onboading_page.dart';
import 'intro/onboading_viewmodel.dart';
import 'login/login_page.dart';
import 'login/login_viewmodel.dart';
import 'utils/sp_helper.dart';  // Ensure this points to your SharedPreferencesHelper file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize SharedPreferences
  await SharedPreferencesHelper.init();

  runApp(TodoListApp());
}

class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginPageScreenViewModel()),
        ChangeNotifierProvider(create: (_) => IntroViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => HomeScreenViewModel()),
        ChangeNotifierProvider(create: (_) => StartScreenViewModel()),
        ChangeNotifierProvider(create: (_) => BottomSheetViewModel()),
        ChangeNotifierProvider(create: (_) => CardViewModel()),
        ChangeNotifierProvider(create: (_) => CreateCategoryViewModel()),
        ChangeNotifierProvider(create: (_) => EditCardViewModel()),
        ChangeNotifierProvider(create: (_) => TableCalendarViewModel()),
        ChangeNotifierProvider(create: (_) => TagCategoryViewModel()),
        ChangeNotifierProvider(create: (_) => TaskPriorityViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
       // ChangeNotifierProvider(create: (_) => BottomSheetViewModel()),
      ],
      child: MaterialApp(
        home: GetMaterialApp(
          debugShowCheckedModeBanner: false, // Optional: Remove the debug banner
          initialRoute: '/splash',
          theme: ThemeData(
            fontFamily: 'Montserrat',
            scaffoldBackgroundColor: Colors.black, // Set the default background color to black
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.black, // Set AppBar background color to black
              elevation: 0,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white10, // TextField background color
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          getPages: [
            GetPage(name: '/splash', page: () => SplashScreen()),
            GetPage(name: '/onboading', page: () => IntroScreen()),
            GetPage(name: '/start', page: () => StartScreenPage()),
            GetPage(name: '/login', page: () => LoginPageScreen()),
            GetPage(name: '/register', page: () => RegisterPage()),
            GetPage(name: '/mainbottom', page: () => MainBottomPage()),
          ],
        ),
      ),
    );
  }
}






// class HomeScreenViewModel extends ChangeNotifier {
//   List<GetTask> tasks = [];
//   final TextEditingController searchController = TextEditingController();
//   late TextEditingController searchTextController = TextEditingController();
//   List<GetTask> filteredTasks = [];
//   bool showProgressbar = false;
//   int userId = 3; // Default value, will be updated after fetching
//   int selectedTaskId = 0;
//   String userName = "";
//
//   // Future<void> initialize() async {
//   //   userId = await SharedPreferencesHelper.getUserId() ?? 0; // Fetch user ID from SharedPreferences
//   //   print("Fetched User ID: $userId"); // Debugging line
//   //   if (userId != 0) {
//   //     await fetchTasks(userId); // Fetch tasks only if userId is valid
//   //   } else {
//   //     print("User ID not found, cannot fetch tasks.");
//   //   }
//   // }
//
//   Future<void> fetchTasks(int userId) async {
//     showProgressbar = true;
//     final url = '$BASE_url/get_task.php?user_id=$userId';
//     print("Fetching tasks from: $url"); // Debugging line
//
//     try {
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         print("Response from API: $jsonResponse"); // Debugging line
//
//         // Check if jsonResponse is a list or a map
//         if (jsonResponse is List) {
//           // Handle empty list case
//           if (jsonResponse.isEmpty) {
//             print("No tasks found.");
//             tasks = [];
//           } else {
//             // If it's a list, assume it's the tasks data
//             tasks = jsonResponse.map((taskJson) => GetTask.fromJson(taskJson)).toList();
//           }
//         } else if (jsonResponse is Map) {
//           // Check if there is an error message
//           if (jsonResponse.containsKey('error')) {
//             print("API Error: ${jsonResponse['error']}");
//             return; // Exit if there is an error
//           }
//
//           // Check if 'success' key exists and handle it correctly
//           if (jsonResponse['success'] != null) {
//             bool isSuccess;
//
//             if (jsonResponse['success'] is String) {
//               isSuccess = jsonResponse['success'].toLowerCase() == 'true';
//             } else if (jsonResponse['success'] is bool) {
//               isSuccess = jsonResponse['success'];
//             } else if (jsonResponse['success'] is int) {
//               isSuccess = jsonResponse['success'] != 0;
//             } else {
//               print("Unexpected type for success: ${jsonResponse['success'].runtimeType}");
//               isSuccess = false; // Default to false if unexpected type
//             }
//
//             // Proceed if success is true and tasks is a list
//             if (isSuccess && jsonResponse['tasks'] is List) {
//               final List<dynamic> taskList = jsonResponse['tasks'];
//               tasks = taskList.map((taskJson) => GetTask.fromJson(taskJson)).toList();
//             } else {
//               print("Tasks not found or success is false");
//             }
//           } else {
//             print("Success key not found in response");
//           }
//         } else {
//           print("Unexpected response format: $jsonResponse");
//         }
//       } else {
//         throw Exception('Failed to load tasks: ${response.statusCode} - ${response.reasonPhrase}');
//       }
//     } catch (error) {
//       print("Error fetching tasks: $error");
//     } finally {
//       showProgressbar = false;
//       notifyListeners(); // Notify listeners to refresh UI
//     }
//   }
//
//   setLoading(bool loading) {
//     showProgressbar = loading;
//     notifyListeners();
//   }
//
//   refreshUI() {
//     notifyListeners();
//   }
// }
