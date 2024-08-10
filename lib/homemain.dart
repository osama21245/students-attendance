import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:university_attendance/core/common/widget/upgrader.dart';
import 'package:university_attendance/core/utils/rive_utils.dart';
import 'package:university_attendance/features/attendance/presentation/pages/confirm_attendance_screen.dart';
import 'package:university_attendance/features/attendance/presentation/pages/home_screen.dart';
import 'package:university_attendance/features/attendance/presentation/widgets/home/btm_nav_item.dart';
import 'package:university_attendance/features/online_attendance/presentation/screens/test.dart';
import 'package:university_attendance/fl_chart.dart';
import 'core/common/entities/menu.dart';
import 'core/common/entities/user.dart';
import 'features/online_attendance/presentation/screens/feed_screen.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  int indexPage = 0;
  User? user;
  List<Widget> screens = [
    const HomeScreen(),
    const FeedScreen(),
    const ConfirmAttendanceScreen(),
    const LineChartSample1()
  ];
  Menu selectedBottomNav = bottomNavItems.first;

  void updateSelectedBottomNav(Menu menu) {
    if (selectedBottomNav != menu) {
      setState(() {
        selectedBottomNav = menu;
        indexPage = bottomNavItems.indexOf(menu);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press logic here if needed.
        return Future.value(false);
      },
      child: CustomUpgrader(
        widget: Scaffold(
          body: Stack(
            children: [
              PageTransitionSwitcher(
                duration: const Duration(milliseconds: 2000),
                transitionBuilder: (Widget child,
                    Animation<double> primaryAnimation,
                    Animation<double> secondaryAnimation) {
                  return FadeThroughTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
                child: screens.elementAt(indexPage),
              ),
              Positioned(
                bottom: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 137, 136, 136)
                        .withOpacity(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 176, 175, 175)
                            .withOpacity(0.3),
                        offset: const Offset(0, 20),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...List.generate(
                        bottomNavItems.length,
                        (index) {
                          Menu navBar = bottomNavItems[index];
                          return BtmNavItem(
                            navBar: navBar,
                            press: () {
                              updateSelectedBottomNav(navBar);
                              RiveUtils.chnageSMIBoolState(navBar.rive.status!);
                            },
                            riveOnInit: (artboard) {
                              navBar.rive.status = RiveUtils.getRiveInput(
                                  artboard,
                                  stateMachineName:
                                      navBar.rive.stateMachineName);
                            },
                            selectedNav: selectedBottomNav,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
