import 'package:flutter/material.dart';
import 'package:university_attendance/core/theme/app_pallete.dart';

import '../../../../../core/const/image_links.dart';

class CustomHomeUpperWidget extends StatelessWidget {
  final Size size;
  const CustomHomeUpperWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                ImageLinks.appLogo,
                width: size.width * 0.24,
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),

          // Text(
          //   "Attendance dash board",
          //   style: TextStyle(
          //     fontSize: 20,
          //     shadows: [
          //       for (int i = 0; i < (4); i++)
          //         Shadow(
          //           blurRadius: 3.0 * i,
          //           color: AppPallete.primaryColor,
          //         )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
