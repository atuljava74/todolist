import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../widgets/button_widget.dart';
import '../widgets/custom_textfield.dart';
import 'login_viewmodel.dart';

class LoginPageScreen extends StatefulWidget {
  @override
  _LoginPageScreenState createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  late LoginPageScreenViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This code block will be executed after the build completes
      _viewModel.showProgressbar = false;
      _viewModel.refreshUI();
    });
  }
  Widget build(BuildContext context) {
    _viewModel = context.watch<LoginPageScreenViewModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/app_icon.png', // Replace with your image path
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        child: Form(
                          key: _viewModel.formKey1,
                          child: Column(
                            children: [
                             CustomTextField(
                                  title: 'Email ID',
                                  controller: _viewModel.emailController,
                                  hintText: 'Email ID',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    // Simple email regex pattern
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                  borderColor: Color(0xff979797),
                                   hintTextColor: Color(0xffAFAFAF),
                                  borderRadius: 5,
                                  textFieldColor: Colors.transparent,
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  title: 'Password',
                                  controller: _viewModel.passwordController,
                                  hintText: 'Password',
                                  hintTextColor: Color(0xffAFAFAF),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  borderColor: const Color(0xff979797),
                                  borderRadius: 5,
                                  obscureText: true,
                                  showPasswordToggle: true,
                                  textFieldColor: Colors.transparent,
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  width: double.infinity,
                                  child: CustomButton(
                                    text: 'Login',
                                    onPressed: () {
                                      if (_viewModel.formKey1.currentState?.validate() ?? false) {
                                        // Proceed with login logic
                                        _viewModel.submitData(context);
                                        print('Login Button Pressed');
                                      }
                                    },
                                    buttonColor: Color(0xff8687E7),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _viewModel.showProgressbar,
            child: Center(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
