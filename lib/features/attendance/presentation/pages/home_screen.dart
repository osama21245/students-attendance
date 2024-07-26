import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_attendance/core/const/image_links.dart';
import 'package:university_attendance/core/theme/app_pallete.dart';
import 'package:university_attendance/core/utils/check_ban.dart';
import 'package:university_attendance/features/attendance/presentation/widgets/home/custom_attendance_card.dart';
import 'package:university_attendance/features/attendance/presentation/widgets/home/custom_home_upper_widget.dart';
import '../../../../core/common/cubit/app_user/app_user_cubit.dart';
import '../widgets/home/custom_date_box.dart';
import '../widgets/home/custom_frosted_glass_box.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        (BlocProvider.of<AppUserCubit>(context).state as AppUserIsLogIn).user;

    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
                bottom: -size.width * 0.3,
                right: size.width * 0.3,
                child: Image.asset(
                  ImageLinks.cube,
                  width: size.width * 1.3,
                )),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: const SizedBox(),
              ),
            ),
            Positioned(
                top: size.height * 0.18,
                left: size.width * 0.01,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    ImageLinks.ring,
                    width: size.width * 1,
                  ),
                )),
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
                CustomHomeUpperWidget(
                  size: size,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomForstedGlassBox(
                      size: size,
                    ),
                    CustomDateBox(
                      size: size,
                    ),
                  ],
                ),
                Text("${user.banDate ?? ""}"),
                Expanded(
                  child: ListView(
                    children: [
                      CustomAttendanceCard(
                        bandDate: user.banDate,
                        color: AppPallete.primaryColor,
                        size: size,
                      ),
                      CustomAttendanceCard(
                        bandDate: user.banDate,
                        color: AppPallete.gradient2,
                        size: size,
                      ),
                      CustomAttendanceCard(
                        bandDate: user.banDate,
                        color: AppPallete.gradient4,
                        size: size,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
