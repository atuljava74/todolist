import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leftWidget; // Widget for the left side
  final Widget? rightWidget; // Widget for the right side
  final String title; // Title text for the center

  AppBarWidget({
    Key? key,
    this.leftWidget,
    this.rightWidget,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      title: Center(
        child: Text(
            title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Jost',
            color: Colors.white,
          ),
        ),
      ),
      leading: leftWidget != null ? leftWidget : null, // Left widget
      actions: [
        if (rightWidget != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Optional padding
            child: rightWidget,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Standard app bar height
}
