import 'package:university_attendance/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:university_attendance/core/theme/theme_data.dart';
import 'package:university_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:university_attendance/features/auth/presentation/pages/login_page.dart';
import 'package:university_attendance/features/online_attendance/presentation/screens/test.dart';
import 'package:university_attendance/homemain.dart';
import 'package:university_attendance/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/common/entities/user.dart';
import 'core/utils/get_user_data.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'features/auth/presentation/pages/take_photos_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      BlocProvider(create: (_) => serviceLocator<AttendanceBloc>()),
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      // BlocSelector<AppUserCubit, AppUserState, bool>(
      //   selector: (state) {
      //     return state is AppUserIsLogIn;
      //   },
      //   builder: (context, isLogIn) {
      //     // if (isLogIn) {
      //     return const HomeScreen();
      //     //  } else {
      //     return const HomeScreen();
      //     //  }
      //   },
      // ),
    );
  }
}
