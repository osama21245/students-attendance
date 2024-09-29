import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  const CustomTextField({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0.w),
      child: SizedBox(
        width: 320.w,
        height: 45.h,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 0.5.w,
              ),
              child: Container(
                padding: EdgeInsets.only(bottom: 5.h),
                width: 320.w,
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      width: 1.5,
                      color: const Color.fromARGB(125, 164, 253, 213)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.h),
              width: 320.w,
              height: 45.h,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff011B21),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Color.fromARGB(0, 255, 255, 255)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r)),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter $title here",
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(122, 255, 255, 255)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
