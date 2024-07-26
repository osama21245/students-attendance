import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_pallete.dart';

class CustomDateBox extends StatelessWidget {
  final Size size;
  const CustomDateBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    DateFormat formatterday = DateFormat('EEEE');
    DateFormat formatterhour = DateFormat('h a');
    DateFormat formatterdate = DateFormat('MMM dd, yyyy');

    DateTime now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            width: size.width * 0.4,
            height: size.height * 0.2,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                  Color.fromARGB(121, 63, 221, 97),
                  AppPallete.backgroundColor
                ])),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        Icon(
                          Icons.date_range_outlined,
                          size: size.width * 0.05,
                        ),
                        SizedBox(
                          width: size.width * 0.025,
                        ),
                        Text(
                          "Date",
                          style: TextStyle(
                              fontSize: size.width * 0.037,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(217, 255, 254, 254)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      "Day: ${formatterday.format(now)}",
                      style: TextStyle(
                          fontSize: size.width * 0.036,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(165, 234, 234, 234)),
                    ),
                    Text(
                      "Date: ${formatterdate.format(now)}",
                      style: TextStyle(
                          fontSize: size.width * 0.036,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(165, 234, 234, 234)),
                    ),
                    Text(
                      "Hour: ${now.hour}:${now.minute}",
                      style: TextStyle(
                          fontSize: size.width * 0.036,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(165, 234, 234, 234)),
                    ),
                    Divider(),
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${formatterhour.format(now)}",
                          style: TextStyle(
                              fontSize: size.width * 0.043,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromARGB(190, 63, 221, 97)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
