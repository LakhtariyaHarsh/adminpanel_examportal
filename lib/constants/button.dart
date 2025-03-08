import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String? route;
  final VoidCallback? onPressed; // Function to be executed
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final double width;
  final double height;

  const CustomButton({
    Key? key,
    required this.text,
    this.route,
    this.onPressed, // Accepts a function
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 0.0,
    this.fontSize = 16.0,
    this.width = 150,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!(); // Call function if provided
          } else if (route != null) {
            context.push(route!); // Navigate if route is provided
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
