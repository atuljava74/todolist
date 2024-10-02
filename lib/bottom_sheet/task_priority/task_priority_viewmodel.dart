import 'package:flutter/cupertino.dart';

class TaskPriorityViewModel extends ChangeNotifier {
  int? _selectedIndex;

  int? get selectedIndex => _selectedIndex;

  set selectedIndex(int? index) {
    _selectedIndex = index;
    notifyListeners();  // This will notify the UI to rebuild when the selection changes
  }

  // Method to refresh the UI manually, if needed
  refreshUI() {
    notifyListeners();
  }
}
