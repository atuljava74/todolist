import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconWidget extends StatefulWidget {
  final dynamic icon; // Can be a String (for SVG) or a Widget
  final bool showBorder; // Control whether to show border
  final Color borderColor; // Color for the border, defaults to black
  final double? height; // Optional height parameter
  final VoidCallback? onTap; // Callback function for tap events

  const IconWidget({
    Key? key,
    required this.icon,
    this.showBorder = false, // Default value is false
    this.borderColor = Colors.black, // Default border color is black
    this.height,
    this.onTap, // Add onTap to the constructor
  }) : super(key: key);

  @override
  State<IconWidget> createState() => _IconWidgetState();
}

class _IconWidgetState extends State<IconWidget> {
  @override
  Widget build(BuildContext context) {
    // Calculate the icon size considering padding
    double iconSize = (widget.height != null) ? widget.height! - 8.0 : 24.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(4.0), // Small padding inside container
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Circular container
          border: widget.showBorder
              ? Border.all(
                  color: widget.borderColor, width: 1.0) // Show border if true
              : null, // No border if showBorder is false
        ),
        child: _buildIcon(iconSize), // Build icon based on type and size
      ),
    );
  }

  // Helper method to build the icon based on its type and size
  Widget _buildIcon(double iconSize) {
    if (widget.icon is String) {
      // If it's a string, treat it as an SVG path
      return SvgPicture.asset(
        widget.icon as String,
        width: iconSize, // Use the calculated icon size
        height: iconSize,
      );
    } else if (widget.icon is Widget) {
      // If it's a widget, wrap it with SizedBox to control size
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: widget.icon as Widget,
      );
    } else {
      // If neither, return a placeholder (optional)
      return Icon(
        Icons.error,
        size: iconSize,
      ); // Fallback in case of an invalid type
    }
  }
}
