import 'package:flutter/material.dart';

import 'button_widget.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final List<Widget> content;
  final VoidCallback onPositiveButtonPressed;
  final VoidCallback? onNegativeButtonPressed;
  final String positiveButtonText;
  final String negativeButtonText;
  final double borderRadius;
  final bool showCancelButton; // Parameter to control visibility of the cancel button

  // Add parameters for custom buttons
  final Widget? customNegativeButton; // Optional custom TextButton
  final Widget? customPositiveButton; // Optional custom OK Button

  const CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onPositiveButtonPressed,
    this.onNegativeButtonPressed,
    this.positiveButtonText = "OK",
    this.negativeButtonText = "Cancel",
    this.borderRadius = 5,
    this.showCancelButton = true, // Default is true (show cancel button)
    this.customNegativeButton, // Custom TextButton
    this.customPositiveButton, // Custom OK Button
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      backgroundColor: const Color(0xff363636),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Jost',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: content,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to the right
              children: [
                if (showCancelButton) // Conditionally render the cancel button
                  customNegativeButton ?? TextButton(
                    onPressed: onNegativeButtonPressed,
                    child: Text(
                      negativeButtonText,
                      style: const TextStyle(
                        color: Color(0xff8687E7),
                        fontSize: 18,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                customPositiveButton ?? CustomButton(
                  text: positiveButtonText,
                  onPressed: onPositiveButtonPressed,
                  buttonColor: const Color(0xff8687E7),
                  borderRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
