import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../bottom_sheet/main_bottom_bar.dart';
import '../intro/onboading_page.dart';
import '../utils/sp_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Optional: Show splash screen for 2 seconds
    final loginInfo = await SharedPreferencesHelper.getLoginInfo();

    if (loginInfo['email'] != null && loginInfo['password'] != null) {
      // If login details are found, navigate to the main page
      Get.to(() => MainBottomPage());
    } else {
      // If no login details, navigate to the login page
      Get.to(() => IntroScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_icon.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Todo List',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                fontFamily: 'Jost',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

