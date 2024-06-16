import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_attendance/core/utils/arabic_to_english_num.dart';
import 'package:university_attendance/features/auth/presentation/widgets/auth_gradient_button.dart';

import '../../../../core/common/widget/loader.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../bloc/attendance_bloc.dart';

class CheckAttendanceScreen extends StatefulWidget {
  const CheckAttendanceScreen({super.key});

  @override
  State<CheckAttendanceScreen> createState() => _CheckAttendanceScreenState();
}

class _CheckAttendanceScreenState extends State<CheckAttendanceScreen> {
  String _bssid = '';
  String _targetBssid = '92:A5:73:EA:9B:99'; // عنوان BSSID المحدد
  Timer? _timer;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _startCheckingConnection();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCheckingConnection() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      context.read<AttendanceBloc>().add(AttendanceCheckWifiConnection());
    });
  }

  // Future<void> _checkWifiConnection() async {

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceFail) {
            showSnackBar(context, state.message);
            _bssid = state.message;
            setState(() {});
          } else if (state is AttendanceSuccess) {
            _bssid = arabicToEnglish(state.bssid);
          }
        },
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Loader();
          }
          return SafeArea(
              child: Center(
            child: Column(
              children: [
                Container(
                  child: Text("=========$_bssid"),
                ),
                AuthGradientButton(
                    buttonText: "Test",
                    onPressed: () {
                      if (_bssid == _targetBssid) {
                        print("connect");
                      } else {
                        print("not connect");
                      }
                    })
              ],
            ),
          ));
        },
      ),
    );
  }
}
