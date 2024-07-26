import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:university_attendance/core/theme/app_pallete.dart';
import 'package:university_attendance/core/utils/check_ban.dart';
import 'package:university_attendance/core/utils/navigation.dart';
import 'package:university_attendance/features/attendance/presentation/pages/check_attendance_screen.dart';

class CustomAttendanceCard extends StatefulWidget {
  final Color color;
  final Size size;
  final String bandDate;
  const CustomAttendanceCard(
      {super.key,
      required this.size,
      required this.color,
      required this.bandDate});

  @override
  State<CustomAttendanceCard> createState() => _CustomAttendanceCardState();
}

class _CustomAttendanceCardState extends State<CustomAttendanceCard> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isBanned(widget.bandDate)) {
          print("GetOut");
        } else {
          navigationOf(context, CheckAttendanceScreen());
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.size.height * 0.008,
            bottom: widget.size.height * 0.02,
            left: widget.size.height * 0.01,
            right: widget.size.height * 0.01),
        child: Listener(
          onPointerDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onPointerUp: (_) {
            setState(() {
              isPressed = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
            height: widget.size.height * 0.23,
            width: widget.size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppPallete.backgroundColor,
                border: Border.all(color: Colors.white),
                boxShadow: [
                  for (int i = 0; i < (isPressed ? 8 : 4); i++)
                    BoxShadow(
                      color: widget.color,
                      blurRadius: 3.0 * i,
                      blurStyle: BlurStyle.outer,
                    )
                ]),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lecture",
                        style: TextStyle(
                          fontSize: widget.size.width * 0.05,
                          shadows: [
                            for (int i = 0; i < (isPressed ? 8 : 4); i++)
                              Shadow(
                                blurRadius: 3.0 * i,
                                color: widget.color,
                              )
                          ],
                        ),
                      ),
                      const CircleAvatar(
                        backgroundColor: Color.fromARGB(74, 108, 108, 108),
                        backgroundImage: AssetImage(
                            "assets/avatars/illustration-business-people-avatar.png"),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Doctor: Hafez Abd El waheed",
                        style: TextStyle(
                            fontSize: widget.size.width * 0.032,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(154, 181, 180, 180)),
                      ),
                      Text(
                        "Course: Computer network and securty",
                        style: TextStyle(
                            fontSize: widget.size.width * 0.032,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(154, 181, 180, 180)),
                      ),
                      Text(
                        "Time: 11:00 - 12:00",
                        style: TextStyle(
                            fontSize: widget.size.width * 0.032,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(154, 181, 180, 180)),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Attend now:",
                            style: TextStyle(
                                fontSize: widget.size.width * 0.04,
                                fontWeight: FontWeight.w600,
                                color:
                                    const Color.fromARGB(154, 181, 180, 180)),
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Attend",
                                style: TextStyle(color: widget.color),
                              )),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            // Center(
            //   child:
            // Text(
            //     "Test",
            //     style: TextStyle(
            //       fontSize: 30,
            //       shadows: [
            //         for (int i = 0; i < (isPressed ? 8 : 4); i++)
            //           Shadow(
            //             blurRadius: 3.0 * i,
            //             color: AppPallete.gradient2,
            //           )
            //       ],
            //     ),
            //   ),
            // )
          ),
        ),
      ),
    );
  }
}
