import 'package:flutter/material.dart';

class AttendanceButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color color;
  const AttendanceButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(color),
          side: MaterialStatePropertyAll(BorderSide(color: color, width: 1.5)),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ));
  }
}
