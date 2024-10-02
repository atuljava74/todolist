import 'dart:convert';
import 'package:flutter/material.dart';
import '../../utils/sp_helper.dart'; // Your SharedPreferences helper

class TagCategoryViewModel extends ChangeNotifier {
  // Predefined default categories (image paths, labels, and colors)
  List<String> imagePaths = [
    "assets/grocery.svg",
    "assets/work.svg",
    "assets/sport.svg",
    "assets/design.svg",
    "assets/university.svg",
    "assets/social.svg",
    "assets/music.svg",
    "assets/health.svg",
    "assets/movie.svg",
    "assets/home.svg",
  ];

  List<String> labels = [
    "Grocery",
    "Work",
    "Sport",
    "Design",
    "University",
    "Social",
    "Music",
    "Health",
    "Movie",
    "Home",
  ];

  List<Color> colors = [
    const Color(0xffCCFF80),
    const Color(0xffFF9680),
    const Color(0xff80FFFF),
    const Color(0xff80FFD9),
    const Color(0xff809CFF),
    const Color(0xffFF80EB),
    const Color(0xffFC80FF),
    const Color(0xff80FFA3),
    const Color(0xff80D1FF),
    const Color(0xffFFCC80),
  ];

  // Lists for dynamic categories added by the user
  List<String> newCategoryLabels = [];
  List<String> newCategoryIcons = [];
  List<Color> newCategoryColors = [];

  int selectedCategoryIndex = -1; // Default no selection
  int selectedNewCategoryIndex = -1;

  List<Map<String, dynamic>> allCategories = []; // Holds all categories including new ones
  final SharedPreferencesHelper _prefsService = SharedPreferencesHelper(); // Instance of the service

  // Constructor - loads the categories when the ViewModel is initialized
  TagCategoryViewModel() {
    loadCategories(); // Load categories on init
  }

  // Method to load categories from SharedPreferences
  Future<void> loadCategories() async {
    print("Loading categories from SharedPreferences...");
    // Load categories from SharedPreferences
    List<Map<String, dynamic>> loadedCategories = await SharedPreferencesHelper.loadCategories();

    if (loadedCategories.isNotEmpty) {
      print('Loaded categories: $loadedCategories');

      // Clear existing categories
      newCategoryLabels.clear();
      newCategoryIcons.clear();
      newCategoryColors.clear();

      // Rebuild the lists from the loaded data
      for (var category in loadedCategories) {
        newCategoryLabels.add(category['label']);
        newCategoryIcons.add(category['icon']);
        newCategoryColors.add(Color(category['color']));
      }

      // Set all categories to be the loaded ones
      allCategories = loadedCategories;
    } else {
      print("No categories found, initializing default categories.");
      allCategories = []; // Set as empty list if none found
    }

    // Notify listeners to refresh UI
    notifyListeners();
  }

  // Method to add a new category
  void addCategory(String label, String icon, Color color) async {
    newCategoryLabels.add(label);
    newCategoryIcons.add(icon);
    newCategoryColors.add(color);

    // Add the new category to the list
    allCategories.add({
      'label': label,
      'icon': icon,
      'color': color.value, // Store color as an int value
    });

    // Save updated categories to SharedPreferences
    await SharedPreferencesHelper.saveCategories(allCategories);

    // Reload categories to refresh the UI
    await loadCategories();
  }

  // Method to select a category
  void selectCategory(int index, BuildContext context) {
    // Determine if the index is for a new category or an existing one
    if (index < labels.length) {
      selectedCategoryIndex = index; // For predefined categories
    } else {
      int newIndex = index - labels.length; // Correct index for new categories
      if (newIndex < newCategoryLabels.length) {
        selectedCategoryIndex = labels.length + newIndex; // Update for the combined index
      } else {
        selectedCategoryIndex = -1; // Reset if accessing an invalid index
      }
    }

    notifyListeners(); // Update UI

    // Only pop if it's a valid selection
    if (selectedCategoryIndex != -1) {
      String selectedLabel = selectedCategoryIndex < labels.length
          ? labels[selectedCategoryIndex]
          : newCategoryLabels[selectedCategoryIndex - labels.length];

      Navigator.of(context).pop({
        'label': selectedLabel,
        'color': selectedCategoryIndex < labels.length ? colors[selectedCategoryIndex] : newCategoryColors[selectedCategoryIndex - labels.length],
        'icon': selectedCategoryIndex < labels.length ? imagePaths[selectedCategoryIndex] : newCategoryIcons[selectedCategoryIndex - labels.length],
      });
    }
  }



  // Method to refresh UI
  void refreshUI() {
    notifyListeners();
  }
}
