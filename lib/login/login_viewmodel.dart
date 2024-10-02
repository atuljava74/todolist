import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bottom_sheet/main_bottom_bar.dart';
import '../services/auth_service.dart';
import '../utils/sp_helper.dart';
import '../utils/utils.dart';
import '../widgets/dialog_widget.dart';

class LoginPageScreenViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final formKey1 = GlobalKey<FormState>();
  bool showProgressbar = false;

  refreshUI() {
    notifyListeners();
  }

  Future<void> submitData(BuildContext context) async {
    if (formKey1.currentState?.validate() ?? false) {
      showProgressbar = true;
      refreshUI();
      String email = emailController.text;
      String password = passwordController.text;

      try {
        // Update to get a map from loginGet
        final response = await AuthService.loginGet(email, password);

        showProgressbar = false;
        refreshUI();

        if (response['result'] == 1) {
          // Retrieve user_id and name
          String userId = response['user_id'];
          String userName = response['name']; // Get the name
          print(userId);
          await SharedPreferencesHelper.saveLoginInfo(email, password, userName); // Save user info
          await SharedPreferencesHelper.saveUserId(userId); // Save user_id
          Utils.userId = userId;
          // Navigate to the HomePage
          Get.to(() => MainBottomPage());
        }
        else if (response['result'] == -1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(
                showCancelButton: false,
                customPositiveButton: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
                title: 'Error',
                content: const [
                  Text(
                    'Invalid email or password.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
                onPositiveButtonPressed: () {},
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(
                showCancelButton: false,
                customPositiveButton: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
                title: 'Error',
                content: const [
                  Text(
                    'Unable to login. Please try again later.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
                onPositiveButtonPressed: () {},
              );
            },
          );
        }
      } catch (e) {
        print('Login failed: $e');
      }

      showProgressbar = false;
      refreshUI();
    }
  }


}
