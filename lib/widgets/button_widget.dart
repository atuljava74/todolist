import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double buttonHeight;
  final double buttonWidth;
  final double borderRadius;
  final double buttonSize;
  final Color buttonColor;
  final Color borderColor; // New parameter for border color
  final double borderWidth; // New parameter for border width

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.buttonHeight = 50, // Default button height
    this.buttonWidth = 150, // Default button width
    this.borderRadius = 5, // Default circular radius
    this.buttonSize = 12, // Default button size
    this.buttonColor = Colors.blue, // Default button color
    this.borderColor = Colors.transparent, // Default border color (no border)
    this.borderWidth = 2.0, // Default border width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: EdgeInsets.zero, // Removed padding to ensure text is centered
          textStyle: TextStyle(fontSize: buttonSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: borderColor, // Use the passed border color
              width: borderWidth, // Use the passed border width
            ),
          ),
        ),
        child: Center( // Ensure that the text is centered within the button
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Jost',
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
