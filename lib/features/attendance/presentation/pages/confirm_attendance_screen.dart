import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_attendance/core/common/widget/loader.dart';
import 'package:university_attendance/core/theme/app_pallete.dart';
import 'package:university_attendance/core/utils/show_snack_bar.dart';

import '../bloc/attendance_bloc.dart';
import '../widgets/confirm_attendance/custom_confirm_attendance_card.dart';

class ConfirmAttendanceScreen extends StatefulWidget {
  const ConfirmAttendanceScreen({super.key});

  @override
  State<ConfirmAttendanceScreen> createState() =>
      _ConfirmAttendanceScreenState();
}

class _ConfirmAttendanceScreenState extends State<ConfirmAttendanceScreen> {
  void getLocalAttendance() {
    context.read<AttendanceBloc>().add(AttendanceGetLocalAttendance());
  }

  @override
  void initState() {
    getLocalAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Atendance"),
        centerTitle: true,
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceFail) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Loader();
          } else if (state is AttendanceGetLocalAttendanceSuccess) {
            return SafeArea(
                child: ListView.builder(
                    itemCount: state.attendance.length,
                    itemBuilder: (context, index) =>
                        CustomConfirmAttendanceCard(
                          bandDate: DateTime.now().toString(),
                          color: AppPallete.gradient1,
                          size: size,
                          sessionId: state.attendance[index].attendance_session,
                        )));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
