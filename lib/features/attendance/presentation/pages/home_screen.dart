import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_attendance/core/common/widget/loader.dart';
import 'package:university_attendance/core/const/image_links.dart';
import 'package:university_attendance/core/theme/app_pallete.dart';
import 'package:university_attendance/features/attendance/presentation/pages/check_attendance_screen.dart';
import 'package:university_attendance/features/attendance/presentation/widgets/home/custom_attendance_card.dart';
import 'package:university_attendance/features/attendance/presentation/widgets/home/custom_home_upper_widget.dart';
import '../../../../core/utils/navigation.dart';
import '../bloc/attendance_bloc.dart';
import '../widgets/home/custom_date_box.dart';
import '../widgets/home/custom_frosted_glass_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getSessions() {
    context.read<AttendanceBloc>().add(AttendanceGetSessions(collageId: 1));
  }

  @override
  void initState() {
    getSessions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user =
    //     (BlocProvider.of<AppUserCubit>(context).state as AppUserIsLogIn).user;

    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
          child: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
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
                    GestureDetector(
                      onTap: () {
                        navigationOf(
                            context,
                            const CheckAttendanceScreen(
                              sessionId:
                                  "widget.sessions.session_id.toString()",
                            ));
                      },
                      child: Listener(
                        onPointerDown: (_) {
                          setState(() {});
                        },
                        onPointerUp: (_) {
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 14),
                          height: size.height * 0.23,
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppPallete.backgroundColor,
                              border: Border.all(color: Colors.white),
                              boxShadow: [
                                for (int i = 0; i < (true ? 8 : 4); i++)
                                  BoxShadow(
                                    color: Colors.blueAccent,
                                    blurRadius: 3.0 * i,
                                    blurStyle: BlurStyle.outer,
                                  )
                              ]),
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: size.width * 0.05,
                                        shadows: [
                                          for (int i = 0;
                                              i < (true ? 8 : 4);
                                              i++)
                                            Shadow(
                                              blurRadius: 3.0 * i,
                                              color: Colors.blueAccent,
                                            )
                                        ],
                                      ),
                                    ),
                                    const CircleAvatar(
                                      backgroundColor:
                                          Color.fromARGB(74, 108, 108, 108),
                                      backgroundImage: AssetImage(
                                          "assets/avatars/illustration-business-people-avatar.png"),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Doctor: ",
                                      style: TextStyle(
                                          fontSize: size.width * 0.032,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              154, 181, 180, 180)),
                                    ),
                                    Text(
                                      "Course: ",
                                      style: TextStyle(
                                          fontSize: size.width * 0.032,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              154, 181, 180, 180)),
                                    ),
                                    Text(
                                      "Time: 11:00 - 12:00",
                                      style: TextStyle(
                                          fontSize: size.width * 0.032,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              154, 181, 180, 180)),
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Attend now:",
                                          style: TextStyle(
                                              fontSize: size.width * 0.04,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromARGB(
                                                  154, 181, 180, 180)),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {},
                                            child: const Text(
                                              "Attend",
                                              style: TextStyle(
                                                  color: Colors.blueAccent),
                                            )),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    //Text("${user.banDate ?? ""}"),
                    // Expanded(
                    //     child:
                    //         //               if (state is AttendanceGetSessions) {
                    //         //   return const Loader();
                    //         // }else{

                    //         // }
                    //         state is AttendanceGetSessionsSuccess
                    //             ? ListView.builder(
                    //                 itemCount: state.sessions.length,
                    //                 itemBuilder: (context, i) =>
                    //                     CustomAttendanceCard(
                    //                   sessions: state.sessions[i],
                    //                   bandDate: //user.banDate
                    //                       state.sessions[i].session_datetime,
                    //                   color: i % 1 == 0
                    //                       ? AppPallete.primaryColor
                    //                       : i % 2 == 0
                    //                           ? AppPallete.gradient2
                    //                           : AppPallete.gradient4,
                    //                   size: size,
                    //                 ),
                    //               )
                    //             : state is AttendanceLoading
                    //                 ? const Loader()
                    //                 : SizedBox())
                  ],
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
