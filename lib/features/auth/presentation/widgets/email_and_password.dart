import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:university_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:university_attendance/features/auth/presentation/widgets/auth_field.dart';

import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/spacer.dart';

import 'password_validations.dart';

class CustomEmailAndPassword extends StatefulWidget {
  const CustomEmailAndPassword({super.key});

  @override
  State<CustomEmailAndPassword> createState() => _CustomEmailAndPasswordState();
}

class _CustomEmailAndPasswordState extends State<CustomEmailAndPassword> {
  bool isObscureText = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;

  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = context.read<AuthBloc>().passwordController;
    setupPasswordControllerListener();
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(passwordController.text);
        hasUppercase = AppRegex.hasUpperCase(passwordController.text);
        hasSpecialCharacters =
            AppRegex.hasSpecialCharacter(passwordController.text);
        hasNumber = AppRegex.hasNumber(passwordController.text);
        hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<AuthBloc>().formKey,
      child: Column(
        children: [
          AuthField(
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isEmailValid(value)) {
                return 'Please enter a valid email';
              }
            },
            hintText: 'Email',
            controller: context.read<AuthBloc>().emailController,
          ),
          verticalSpace(18),
          AuthField(
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isPasswordValid(value)) {
                return 'Please enter a valid password';
              }
            },
            hintText: 'Password',
            controller: context.read<AuthBloc>().passwordController,
          ),
          verticalSpace(24),
          PasswordValidations(
            hasLowerCase: hasLowercase,
            hasUpperCase: hasUppercase,
            hasSpecialCharacters: hasSpecialCharacters,
            hasNumber: hasNumber,
            hasMinLength: hasMinLength,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
