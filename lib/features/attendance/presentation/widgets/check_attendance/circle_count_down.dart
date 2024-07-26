import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_pallete.dart';

class CustomCircleCountDown extends StatelessWidget {
  final CountDownController countDownController;
  final dynamic Function(dynamic Function(Duration), Duration)? onchange;
  final int duration;
  final int initialDuration;
  const CustomCircleCountDown(
      {super.key,
      required this.countDownController,
      required this.onchange,
      required this.duration,
      required this.initialDuration});

  @override
  Widget build(BuildContext context) {
    return CircularCountDownTimer(
        duration: duration,
        initialDuration: initialDuration,
        controller: countDownController,
        width: 300 / 2,
        height: 300 / 2,
        ringColor: Colors.grey[300]!,
        ringGradient: null,
        fillColor: const Color.fromARGB(255, 63, 221, 97),
        fillGradient: null,
        backgroundColor: AppPallete.backgroundColor,
        backgroundGradient: null,
        strokeWidth: 20.0,
        strokeCap: StrokeCap.round,
        textStyle: const TextStyle(
            fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.HH_MM_SS,
        isReverse: true,
        isReverseAnimation: true,
        isTimerTextShown: true,
        autoStart: true,
        onStart: () {
          debugPrint('Countdown Started');
        },
        onComplete: () {
          debugPrint('Countdown Ended');
        },
        onChange: (String timeStamp) {
          debugPrint('Countdown Changed $timeStamp');
        },
        timeFormatterFunction: onchange);
  }
}
