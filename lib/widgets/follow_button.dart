import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Color bgColor;
  final Function()? onPressed;
  final Color borderColor;
  final Color textcolor;
  final String text;

  const FollowButton({
    super.key,
    this.onPressed,
    required this.bgColor,
    required this.borderColor,
    required this.text,
    required this.textcolor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textcolor,
            fontWeight: FontWeight.bold,
          ),
        ),
        height: 27,
        width: 325,
      ),
    );
  }
}
