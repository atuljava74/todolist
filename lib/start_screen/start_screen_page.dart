import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:todolist/screens/login.dart';
import 'package:todolist/start_screen/start_screen_viewmodel.dart';
import 'package:todolist/widgets/button_widget.dart';

import '../login/login_page.dart';
import '../register/register_page.dart';

class StartScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final startScreenViewModel = Provider.of<StartScreenViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,), // Back icon
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top section with two centered texts
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  const Text(
                    'Welcome to Todo List',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Jost',
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Please login to your account or create\nnew account to continue',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Jost',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0,left: 20,right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'LOGIN',
                    buttonColor: const Color(0xff8875FF),
                    onPressed: () {
                      Get.to(() => LoginPageScreen());
                    },
                    buttonHeight: 50,
                    buttonWidth: double.infinity,
                    borderRadius: 5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'CREATE ACCOUNT',
                    buttonColor: Colors.transparent,
                    onPressed: () {
                      // Add your next action here
                      Get.to(() => RegisterPage());
                      print('Next button clicked');
                    },
                    buttonHeight: 50,
                    buttonWidth: 130,
                    borderRadius: 5,
                    borderColor: const Color(0xff8875FF),
                    borderWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
