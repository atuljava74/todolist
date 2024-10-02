import 'dart:io';

import 'package:flutter/cupertino.dart';

class ProfileViewModel extends ChangeNotifier {

  TextEditingController accountNameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  File? selectedImage;

  refreshUI() {
    notifyListeners();
  }

  // Optionally, reset controllers when done
  void resetControllers() {
    accountNameController.clear();
    oldPasswordController.clear();
    newPasswordController.clear();
  }
}
