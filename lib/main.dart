import 'package:university_attendance/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:university_attendance/core/routing/app_router.dart';
import 'package:university_attendance/core/theme/theme_data.dart';
import 'package:university_attendance/features/attendance/presentation/pages/home_screen.dart';
import 'package:university_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:university_attendance/features/auth/presentation/pages/login_page.dart';
import 'package:university_attendance/fl_chart.dart';
import 'package:university_attendance/homemain.dart';
import 'package:university_attendance/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_attendance/user_time_line.dart';
import 'core/common/entities/user.dart';
import 'core/utils/get_user_data.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'features/auth/presentation/pages/take_photos_screen.dart';
import 'test_screen_record.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      BlocProvider(create: (_) => serviceLocator<AttendanceBloc>()),
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
    ],
    child: MyApp(
      appRouter: AppRouter(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    user = await getUserInit();
    if (mounted && user != null) {
      context.read<AppUserCubit>().updateUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.appDarkTheme,
      home: BlocBuilder<AppUserCubit, AppUserState>(
        builder: (context, state) {
          if (state is AppUserIsLogIn) {
            return HomeMain();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
