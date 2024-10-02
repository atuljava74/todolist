import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Color borderColor;
  final Color textFieldColor;
  final double borderRadius;
  final bool obscureText;
  final bool showPasswordToggle;
  final String? title; // Make title optional
  final double borderWidth;
  final Color? hintTextColor;
  final IconData? prefixIcon; // Add optional prefix icon
  final Color? iconColor; // Optional icon color
  final Color? titleColor; // Optional title color
  final Function(String)? onSubmitted; // Add the onSubmitted parameter

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.title, // Now optional
    this.validator,
    this.borderColor = Colors.grey,
    this.textFieldColor = Colors.white,
    this.borderRadius = 10.0,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.borderWidth = 2,
    this.hintTextColor,
    this.prefixIcon, // Optional prefix icon
    this.iconColor = Colors.grey, // Default icon color
    this.titleColor, // Add title color parameter
    this.onSubmitted, // Initialize onSubmitted
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) // Only display title if it's provided
          Text(
            widget.title!,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Jost',
              fontWeight: FontWeight.w500,
              color: widget.titleColor ?? Colors.white, // Use titleColor or default to white
            ),
          ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscured,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontFamily: 'Jost',
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontFamily: 'Jost',
              color: widget.hintTextColor,
            ),
            filled: true,
            fillColor: widget.textFieldColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: widget.borderWidth),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: widget.borderWidth),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: widget.borderWidth),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: Colors.red, width: widget.borderWidth),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: Colors.red, width: widget.borderWidth),
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
              widget.prefixIcon,
              color: widget.iconColor,
            )
                : null, // Display icon only if provided
            suffixIcon: widget.showPasswordToggle
                ? IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            )
                : null,
          ),
          validator: widget.validator,
          onFieldSubmitted: widget.onSubmitted, // Add this line
        ),
      ],
    );
  }
}
