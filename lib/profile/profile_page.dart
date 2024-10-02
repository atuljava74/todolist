import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:todolist/profile/profile_viewmodel.dart';

import '../login/login_page.dart';
import '../pick_image/pick_image.dart';
import '../settings/settings_page.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/dialog_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileViewModel _viewModel;


  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<ProfileViewModel>();
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Profile',
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: _viewModel.selectedImage != null
                        ? FileImage(_viewModel.selectedImage!) // Display selected image
                        : const AssetImage('assets/profile_image.png') as ImageProvider,
                    radius: 60,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: taskContainer("10 Tasks left"),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: taskContainer("5 Tasks done"),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                "Settings",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Jost',
                  color: Color(0xffAFAFAF),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              profileFiles("App Settings", Icons.settings, 0),
              const SizedBox(height: 22),
              const Text(
                "Account",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Jost',
                  color: Color(0xffAFAFAF),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              profileFiles("Change account name", Icons.person, 1),
              const SizedBox(height: 8),
              profileFiles("Change account password", Icons.key, 2),
              const SizedBox(height: 8),
              profileFiles("Change account Image", Icons.camera_alt_outlined, 3), // Updated
              const SizedBox(height: 22),
              const Text(
                "UpTodo",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Jost',
                  color: Color(0xffAFAFAF),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              profileFiles("About US", Icons.password, 4),
              const SizedBox(height: 10),
              profileFiles("FAQ", Icons.error_outline, 5),
              const SizedBox(height: 10),
              profileFiles("Help & Feedback", Icons.cable, 6),
              const SizedBox(height: 10),
              profileFiles("Support US", Icons.thumb_up_outlined, 7),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  //_viewModel.resetControllers(); // Clear any input fields before navigating
                  Get.to(() => LoginPageScreen());
                },
                child: Row(
                  children: [
                    Container(
                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 10),
                          Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Jost',
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Task container widget function
  Widget taskContainer(String title) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff363636),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: 'Jost',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  profileFiles(String text, IconData icon, index) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          // Open dialog when the index is 1
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return changeAccountName();
            },
          );
        }
        if (index == 2) {
          // Open dialog when the index is 2
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return changeAccountPassword();
            },
          );
        }
        if (index == 3) {
          showBottomSheetForImageChange();
        }
        if(index == 0) {
          Get.to(() => SettingsScreenPage());
        }
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 14),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Jost',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: const Icon(Icons.chevron_right, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  changeAccountName() {
    return CustomDialog(
      key: UniqueKey(), // Generate a new key each time the dialog is shown
      title: 'Change account name',
      content: [
        CustomTextField(
          key: UniqueKey(), // Assign a unique key here if needed
          controller: TextEditingController(), // Always use a fresh controller
          hintText: 'Change Account Name',
          hintTextColor: const Color(0xffAFAFAF),
          borderRadius: 5,
          borderColor: Colors.white,
          borderWidth: 0.5,
          textFieldColor: Colors.transparent,
        ),
      ],
      onNegativeButtonPressed: () {
        Navigator.of(context).pop();
      },
      onPositiveButtonPressed: () {},
      positiveButtonText: "Edit",
    );
  }

  changeAccountPassword() {
    return CustomDialog(
      key: UniqueKey(), // Generate a new key each time the dialog is shown
      title: 'Change Account Password',
      content: [
        CustomTextField(
          key: UniqueKey(), // Ensure each text field has a unique key
          controller: _viewModel.oldPasswordController,
          hintText: 'Enter old password',
          title: 'Enter old password',
          titleColor: const Color(0xffAFAFAF),
          hintTextColor: const Color(0xffAFAFAF),
          borderRadius: 5,
          borderColor: Colors.white,
          borderWidth: 0.5,
          textFieldColor: Colors.transparent,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          key: UniqueKey(), // Ensure each text field has a unique key
          controller: _viewModel.newPasswordController,
          hintText: 'Enter new Password',
          title: 'Enter new password',
          titleColor: const Color(0xffAFAFAF),
          hintTextColor: const Color(0xffAFAFAF),
          borderRadius: 5,
          borderColor: Colors.white,
          borderWidth: 0.5,
          textFieldColor: Colors.transparent,
        ),
      ],
      onNegativeButtonPressed: () {
        Navigator.of(context).pop();
      },
      onPositiveButtonPressed: () {},
      positiveButtonText: "Edit",
    );
  }


  void showBottomSheetForImageChange() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 220,
          color: const Color(0xff363636),
          child: PickImage(
            onImagePicked: (File image) {
              setState(() {
                _viewModel.selectedImage = image; // Update the image when picked
              });
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
        );
      },
    );
  }


}
