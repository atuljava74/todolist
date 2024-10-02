import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../start_screen/start_screen_page.dart';

class IntroViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  refreshUI() {
    notifyListeners();
  }

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/manage_task.svg',
      'text': 'You can easily manage all of your daily\ntasks in DoMe for free',
      'title': 'Manage your tasks',
    },
    {
      'image': 'assets/daily_routine.svg',
      'text':
      'In Uptodo  you can create your\npersonalized routine to stay productive',
      'title': 'Create daily routine',
    },
    {
      'image': 'assets/your_task.svg',
      'text':
      'You can organize your daily tasks by\nadding your tasks into separate categories',
      'title': 'Organize your tasks',
    },
  ];


  void onPageChanged(int index) {
    currentPage = index;
      notifyListeners();
  }

  void nextPage() {
    if (currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.to(() => StartScreenPage());
    }
  }

  void skipToLastPage() {
    Get.to(() => StartScreenPage());
  }

  void previousPage() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
