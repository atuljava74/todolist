import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateCategoryViewModel extends ChangeNotifier {

  final TextEditingController nameController = TextEditingController();
  String selectedIcon = "assets/grocery.svg"; // Default icon
  Color selectedColor = Colors.red; // Default color

  final List<Color> colorOptions = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.brown,
    Colors.grey,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.lime,
    Colors.amber,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.blueGrey,
    Colors.black,
    Colors.white,
  ];

  List<String> iconPaths = [
    "assets/sport.svg",
    "assets/grocery.svg",
    "assets/work.svg",
    "assets/design.svg",
    "assets/university.svg",
    "assets/social.svg",
    "assets/music.svg",
    "assets/health.svg",
    "assets/movie.svg",
    "assets/home.svg",
    // Add more icons as needed
  ];

  refreshUI() {
    notifyListeners();
  }
}