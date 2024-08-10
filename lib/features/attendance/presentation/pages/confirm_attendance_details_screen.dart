import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_attendance/core/common/widget/loader.dart';
import 'package:university_attendance/core/theme/app_pallete.dart';
import 'package:university_attendance/features/attendance/presentation/widgets/attendance_gradient_button.dart';
import 'package:university_attendance/features/attendance/presentation/widgets/confirm_attendance_details/custom_first_check_photos.dart';

import '../bloc/attendance_bloc.dart';
import '../widgets/confirm_attendance_details/custom_secound_check_photos.dart';

class ConfirmAttendanceDetailsScreen extends StatefulWidget {
  final String sessionId;
  const ConfirmAttendanceDetailsScreen({super.key, required this.sessionId});

  @override
  State<ConfirmAttendanceDetailsScreen> createState() =>
      _ConfirmAttendanceDetailsScreenState();
}

class _ConfirmAttendanceDetailsScreenState
    extends State<ConfirmAttendanceDetailsScreen> {
  int counter = 0;
  bool firstCheck = false;

  bool secoundCheck = false;
  List<File> _images = [];
  final List<int> _failImagesIndexs = [];

  void _getLocalPhotos() {
    context.read<AttendanceBloc>().add(AttendanceGetLocalPhotos());
  }

  void _checkFirstAndSecoundAttendancePhotos() {
    firstCheck = true;
    secoundCheck = true;
    if (_failImagesIndexs.contains(2) && _failImagesIndexs.contains(3)) {
      secoundCheck = false;
    } else if (_failImagesIndexs.contains(0) && _failImagesIndexs.contains(1)) {
      firstCheck = false;
    }
  }

  void _checkPhotos(List<File> images) {
    // for (File image in images) {
    context.read<AttendanceBloc>().add(AttendanceCheckStudFace(
          image: images[counter],
          studId: "uuid.v1()",
        ));
    //  }
  }

  void _confirmAttendance() {
    // for (File image in images) {
    context.read<AttendanceBloc>().add(AttendanceConfirmAttendance(
          sessionId: widget.sessionId,
          userId: "",
        ));
    //  }
  }

  @override
  void initState() {
    super.initState();
    _getLocalPhotos();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      bottomNavigationBar: AttendanceButton(
          buttonText: "Submit",
          onPressed: () {
            if (!firstCheck || !secoundCheck || counter == 0) {
            } else {
              _confirmAttendance();
            }
          },
          color: !firstCheck || !secoundCheck || counter == 0
              ? AppPallete.greyColor
              : AppPallete.primaryColor),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
        if (state is AttendanceCheckFaceSuccess) {
          if (counter == 3) {
            _getLocalPhotos();
            _checkFirstAndSecoundAttendancePhotos();
          }
          if (state.similarty > 0.5) {
            _failImagesIndexs.add(counter);
          }
          if (counter < 3) {
            counter++;
            _checkPhotos(_images);
          }
        }
        if (state is AttendanceFail) {
          if (counter == 3) {
            _getLocalPhotos();
            _checkFirstAndSecoundAttendancePhotos();
          }
          if (counter <= 3) {
            _failImagesIndexs.add(counter);
            print(counter);
            if (counter != 3) {
              counter++;
              _checkPhotos(_images);
            }
          }
        }
      }, builder: (context, state) {
        if (state is AttendanceLoading) {
          return const Loader();
        } else if (state is AttendanceGetLocalPhotosSuccess) {
          _images = state.file;
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () => _checkPhotos(state.file),
                      child: const Text("Check")),
                  Text(counter.toString()),
                  CustomFirstCheckPhotos(
                    size: size,
                    counter: counter,
                    images: state.file,
                    failImagesIndexs: _failImagesIndexs,
                  ),
                  CustomSecoundCheckPhotos(
                    size: size,
                    counter: counter,
                    images: state.file,
                    failImagesIndexs: _failImagesIndexs,
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                        itemCount: _failImagesIndexs.length,
                        itemBuilder: (context, index) =>
                            Text("${_failImagesIndexs[index]}")),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context
                            .read<AttendanceBloc>()
                            .add(AttendanceConfirmAttendance(
                              sessionId: widget.sessionId,
                              userId: "",
                            ));
                      },
                      child: const Text("Confirm Attendance")),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
