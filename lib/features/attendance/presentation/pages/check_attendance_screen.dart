import 'dart:async';
import 'dart:io';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:university_attendance/core/common/class/local_notification.dart';
import 'package:university_attendance/core/theme/app_pallete.dart';
import 'package:university_attendance/core/utils/check_face_in_photo.dart';
import 'package:university_attendance/core/utils/navigation.dart';
import 'package:university_attendance/core/utils/set_user_data.dart';
import 'package:university_attendance/features/attendance/presentation/widgets/check_attendance/custom_notes_part.dart';
import 'package:university_attendance/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:university_attendance/homemain.dart';
import '../../../../app_test_colors.dart';
import '../../../../core/common/cubit/app_user/app_user_cubit.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/common/widget/loader.dart';
import '../../../../core/utils/check_permissions.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../bloc/attendance_bloc.dart';
import '../widgets/attendance_gradient_button.dart';
import '../widgets/check_attendance/circle_count_down.dart';
import '../widgets/check_attendance/custom_show_photos.dart';

class CheckAttendanceScreen extends StatefulWidget {
  const CheckAttendanceScreen({super.key});

  @override
  State<CheckAttendanceScreen> createState() => _CheckAttendanceScreenState();
}

class _CheckAttendanceScreenState extends State<CheckAttendanceScreen>
    with WidgetsBindingObserver {
  String _bssid = '';
  String _targetBssid = '192.168.1.1'; // عنوان BSSID المحدد
  Timer? _timer;
  DateTime startDate = DateTime.utc(2024, 7, 28, 14, 0, 0);
  DateTime endDate = DateTime.utc(2024, 7, 28, 14, 2, 0);
  Duration? diff;
  int attendTimes = 0;
  int badTime = 0;
  int goodTimesAttended = 0;
  int remainingTime = 0;
  CountDownController? _countDownTimerController;
  bool canAttend = false;
  bool offlineCheck = true;
  List<File> _images = [];
  bool checkPhotos = true;
  File? _image;
  bool showWaitingTime = false;
  User? user;
  LocalNotification _localNotification = LocalNotification();
  //StreamSubscription? _notificationSubscription;

  Timer? _timer2;
  final _badStateTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _banUser(withNav: false, removeBan: true);
        print("resume");
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _banUser(withNav: false, removeBan: false);
        print("pause");
      case AppLifecycleState.detached:
        print("backGround");
        break;
      case AppLifecycleState.hidden:
        print("hidden");
    }
  }

  // ···

  final double universityLatitude =
      31.0960601; // Replace with university's latitude
  final double universityLongitude =
      30.3155396; // Replace with university's longitude
  final double thresholdDistance = 0.5; // 2 kilometers

  @override
  void initState() {
    super.initState();
    user =
        (BlocProvider.of<AppUserCubit>(context).state as AppUserIsLogIn).user;
    diff = endDate.difference(startDate);
    _countDownTimerController = CountDownController();
    WidgetsBinding.instance.addObserver(this);

    FlutterBackground.initialize().then((initialized) {
      if (initialized) {
        FlutterBackground.enableBackgroundExecution();
      }
    });
    _localNotification.init();
    // _notificationSubscription =
    //     LocalNotification.streamController.stream.listen((val) {
    //   print(val.id);
    // });
    _changeStatusBarColor(isReset: false);
    _startCheckingConnection();
    checkPermissions();
    _startAttendTimer();
    _showNotifications();
  }

  @override
  void dispose() async {
    _timer?.cancel();
    _timer2?.cancel();
    _badStateTimer.dispose(); // Need to call dispose function
    FlutterBackground.disableBackgroundExecution();
    WidgetsBinding.instance.removeObserver(this);
    _changeStatusBarColor(isReset: true);
    // _notificationSubscription!.cancel();
    super.dispose();
  }

  void _changeStatusBarColor({required bool isReset}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isReset ? Colors.transparent : AppPallete.primaryColor,
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.dark, // For iOS
      ),
    );
  }

  void _showNotifications() {
    _localNotification.showSceduleNotification(
      "First",
      "body",
      ((diff!.inSeconds / 10) + 5).toInt(),
      0,
    );
    _localNotification.showSceduleNotification(
      "Secound",
      "body",
      ((diff!.inSeconds / 2) + 5).toInt(),
      1,
    );
  }

  Future<void> _getImage(bool withOnlineCheck) async {
    _loading();
    final pickedFile =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform
            .getImage(source: ImageSource.camera, imageQuality: 100);

    if (pickedFile != null) {
      if (!withOnlineCheck) {
        _image = File(pickedFile.path);

        if (await checkFaceInPhoto(_image!, context)) {
          //Backup image
          if (_images.length == 1 || _images.length == 3) {
            attendTimes++;
            canAttend = false;
            checkPhotos = true;
          }
          _images.add(_image!);

          print(_images.length);
          setState(() {});
        }
      }
    }
    _stopLoading();
  }

  void checkFace() {
    context.read<AttendanceBloc>().add(AttendanceCheckStudFace(
          image: _image!,
          studId: "uuid.v1()",
        ));
  }

  void addPhotosToSharedPref() {
    context.read<AttendanceBloc>().add(AttendanceSetLocalPhotos(
          file: _images,
        ));
  }

  void _startCheckingConnection() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (badTime > 2000) {
        _banUser(withNav: true, removeBan: false);
      }
      context.read<AttendanceBloc>().add(AttendanceConfirmQualifications(
          attendbssid: '192.168.1.1',
          attendLat: universityLatitude,
          attendLong: universityLongitude,
          attendDistance: 10));
    });
  }

  void _banUser({required bool withNav, required bool removeBan}) {
    remainingTime = diff!.inSeconds - goodTimesAttended;
    user = user!.copyWith(
        banDate: removeBan
            ? DateTime.now().toString()
            : DateTime.now().add(Duration(seconds: remainingTime)).toString());
    context.read<AppUserCubit>().updateUser(user);
    if (withNav) {
      navigationOf(context, HomeMain());
    }
    setUserData(user!);
    print(user!.banDate);
    //  showSnackBar(context, "you are banned from this lecture");
  }

  void _startAttendTimer() {
    _timer2 = Timer.periodic(Duration(seconds: (diff!.inSeconds / 20).toInt()),
        (timer) async {
      if (goodTimesAttended > diff!.inSeconds / 10 && attendTimes == 0) {
        checkPhotos = false;
        canAttend = true;
        setState(() {});
      } else if (goodTimesAttended > diff!.inSeconds / 2 && attendTimes == 1) {
        checkPhotos = false;
        canAttend = true;
        setState(() {});
      }
    });
  }

  void _saveAttendance() {
    context.read<AttendanceBloc>().add(AttendanceSetLocalAttendance(
        bssid: '', id: '', time: '', stdId: '', date: '', status: ''));
  }

  void _savePhotos() {
    context.read<AttendanceBloc>().add(AttendanceSetLocalPhotos(file: _images));
  }

  void _loading() {
    context.read<AttendanceBloc>().add(AttendanceStartLoading());
  }

  void _stopLoading() {
    context.read<AttendanceBloc>().add(AttendanceStopLoading());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceSetLocalAttendanceSuccess) {
            _savePhotos();
          } else if (state is AttendanceSetLocalPhotosSuccess) {
            navigationOf(context, HomeMain());
            showSnackBar(context, "Your attendance added successfully");
          } else if (state is AttendanceCheckFaceSuccess) {
          } else if (state is AttendanceSetLocalPhotosSuccess) {
            attendTimes++;
            canAttend = false;
            print("$attendTimes");
          } else if (state is AttendanceRejectQualifications) {
            showSnackBar(context, state.message);
            showWaitingTime = true;
            _badStateTimer.onStartTimer();
          } else if (state is AttendanceConfirmQualificationsSucess) {
            print(state.isQualified);
            if (state.isQualified && checkPhotos) {
              showWaitingTime = false;
              _badStateTimer.onStopTimer();
            }
            //  setState(() {});
          }
        },
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Loader();
          }
          return SafeArea(
              child: Padding(
            padding: EdgeInsets.all(size.width * 0.06),
            child: Center(
              child: Column(
                children: [
                  CustomCircleCountDown(
                      countDownController: _countDownTimerController!,
                      onchange: (defaultFormatterFunction, duration) {
                        goodTimesAttended =
                            diff!.inSeconds - duration.inSeconds;
                        if (duration.inSeconds == 0) {
                          return "End";
                        } else {
                          return Function.apply(
                              defaultFormatterFunction, [duration]);
                        }
                      },
                      duration: diff!.inSeconds,
                      initialDuration: goodTimesAttended),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 1700),
                    opacity: showWaitingTime ? 1 : 0,
                    child: StreamBuilder<int>(
                      stream: _badStateTimer.rawTime,
                      initialData: 0,
                      builder: (context, snap) {
                        final value = snap.data;
                        badTime = value! ~/ 1000;
                        final displayTime =
                            StopWatchTimer.getDisplayTime(value);

                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "Waiting time: ${displayTime}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (canAttend && offlineCheck)
                    AuthGradientButton(
                        buttonText:
                            "${attendTimes == 0 && _images.length == 0 ? "First Attendance : offline" : _images.length == 1 || _images.length == 3 ? "Backup image" : "Second Attendance"}",
                        onPressed: () {
                          if (canAttend && attendTimes == 0) {
                            _getImage(false);
                          } else if (canAttend && attendTimes == 1) {
                            _getImage(false);
                          } else {}
                        }),
                  // if (canAttend && onlineCheck)
                  //   AuthGradientButton(
                  //       buttonText:
                  //           "${attendTimes == 0 ? "First Attendance : online" : "Second Attendance"}",
                  //       onPressed: () {
                  //         if (canAttend && attendTimes == 0) {
                  //           offlineCheck = false;
                  //           _getImage(true);
                  //         } else if (canAttend && attendTimes == 1) {
                  //           _getImage(true);
                  //         } else {}
                  //       }),
                  if (attendTimes == 2)
                    AttendanceButton(
                        color: AppPallete.primaryColor,
                        buttonText: "Save Attendance",
                        onPressed: () => _saveAttendance()),
                  CustomShowPhotos(size: size, images: _images),

                  Text(user!.banDate),
                  const Spacer(),
                  CustomNotesPart(size: size)
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}
