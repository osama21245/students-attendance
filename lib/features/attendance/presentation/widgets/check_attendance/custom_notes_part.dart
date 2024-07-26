import 'package:flutter/material.dart';

class CustomNotesPart extends StatelessWidget {
  final Size size;
  const CustomNotesPart({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Note: your maximum waiting time is 15 mun",
              style: TextStyle(
                  fontSize: size.width * 0.03,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.001,
        ),
        Text(
          "Note: You can only attend once , don't leave this page , if you close this page your attendance will be rejected , if you close the app your attendance will be rejected",
          style: TextStyle(
              fontSize: size.width * 0.03,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
