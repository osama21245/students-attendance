import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../../../../../core/theme/app_pallete.dart';

class CustomForstedGlassBox extends StatelessWidget {
  final Size size;
  const CustomForstedGlassBox({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: size.width * 0.5,
        height: size.height * 0.2,
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                    ]),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                                "assets/avatars/large-group-people-sitting-auditorium-watching-presentation-generated-by-ai.jpg"),
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Text(
                            "OSAMA AHMED",
                            style: TextStyle(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w800,
                                color:
                                    const Color.fromARGB(154, 181, 180, 180)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Text(
                        "Collage: Mti university",
                        style: TextStyle(
                            fontSize: size.width * 0.032,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(154, 181, 180, 180)),
                      ),
                      Text(
                        "Faculty: Computer science",
                        style: TextStyle(
                            fontSize: size.width * 0.032,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(154, 181, 180, 180)),
                      ),
                      Text(
                        "Semester: Fall 2024",
                        style: TextStyle(
                            fontSize: size.width * 0.032,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(154, 181, 180, 180)),
                      ),
                      const Divider(),
                      Text(
                        "Level: 3",
                        style: TextStyle(
                            fontSize: size.width * 0.043,
                            fontWeight: FontWeight.w800,
                            color: AppPallete.primaryColor),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
