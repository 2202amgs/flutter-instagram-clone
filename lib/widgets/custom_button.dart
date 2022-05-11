import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final String text;
  final VoidCallback? onPressed;
  const CustomButton({
    Key? key,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: 250,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
