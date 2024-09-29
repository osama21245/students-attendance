import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:university_attendance/homemain.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/style.dart';

class GetStartBtn extends StatefulWidget {
  const GetStartBtn({
    super.key,
    required this.size,
    required this.textTheme,
  });

  final Size size;
  final TextTheme textTheme;

  @override
  State<GetStartBtn> createState() => _GetStartBtnState();
}

class _GetStartBtnState extends State<GetStartBtn> {
  bool isLoading = false;

  loadingHandler() {
    setState(() {
      isLoading = true;
      Future.delayed(const Duration(seconds: 2)).then((value) {
        isLoading = false;
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (_) => const HomeMain()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loadingHandler,
      child: Container(
        margin: const EdgeInsets.only(top: 60),
        width: widget.size.width / 1.5,
        height: widget.size.height / 13,
        decoration: BoxDecoration(
            color: AppPallete.btnColor,
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : Text("Get Started now", style: TextStyles.font18WhiteBold),
        ),
      ),
    );
  }
}

class SkipBtn extends StatelessWidget {
  const SkipBtn({
    super.key,
    required this.size,
    required this.textTheme,
    required this.onTap,
  });

  final Size size;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      width: size.width / 1.5,
      height: size.height / 13,
      decoration: BoxDecoration(
          border: Border.all(
            color: AppPallete.btnBorderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onTap,
        splashColor: AppPallete.btnBorderColor,
        child: Center(
          child: Text("Skip", style: TextStyles.font18lightGreenBold),
        ),
      ),
    );
  }
}
