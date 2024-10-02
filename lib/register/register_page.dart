import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:todolist/register/register_viewmodel.dart';

import '../widgets/button_widget.dart';
import '../widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late RegisterViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<RegisterViewModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                          'assets/app_icon.png',
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _viewModel.formKey2,
                        child: Column(
                          children: [
                            CustomTextField(
                              title: 'Username',
                              controller: _viewModel.usernameController,
                              hintText: 'Username',
                              hintTextColor: const Color(0xffAFAFAF),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              borderColor: const Color(0xff979797),
                              borderRadius: 5,
                              textFieldColor: Colors.transparent,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              title: 'Email ID',
                              controller: _viewModel.emailController,
                              hintText: 'Email ID',
                              hintTextColor: const Color(0xffAFAFAF),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              borderColor: const Color(0xff979797),
                              borderRadius: 5,
                              textFieldColor: Colors.transparent,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              title: 'Password',
                              controller: _viewModel.passwordController,
                              hintText: 'Password',
                              hintTextColor: const Color(0xffAFAFAF),
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
                                text: _viewModel.isLoading ? 'Loading...' : 'Register',
                                // Ensure onPressed is a non-nullable function
                                onPressed: _viewModel.isLoading
                                    ? () {} // Provide a no-op function if loading
                                    : () {
                                  if (_viewModel.formKey2.currentState?.validate() ?? false) {
                                    _viewModel.registerUser(context);
                                  }
                                },
                                buttonColor: const Color(0xff8687E7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
