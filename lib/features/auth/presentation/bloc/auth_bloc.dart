import 'package:bloc/bloc.dart';
import 'package:university_attendance/features/auth/domain/usecases/current_user.dart';
import 'package:university_attendance/features/auth/domain/usecases/user_sign_in.dart';
import 'package:university_attendance/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';

import '../../../../core/common/cubit/app_user/app_user_cubit.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/common/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final GetCurrentUser _getCurrentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc(
      {required UserSignUp userSignUp,
      required UserSignIn userSignIn,
      required GetCurrentUser getCurrentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _getCurrentUser = getCurrentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthSignUp>(_authSignUp);
    on<AuthSignIn>(_authSignIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _getCurrentUser(NoParams());

    res.fold(
      (l) => emit(AuthFail(l.toString())),
      (r) => _emitAuthSuccess(r!, emit),
    );
  }

  void _authSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
        UserSignUpParams(event.email, event.password, event.name));

    res.fold((l) {
      emit(AuthFail(l.erorr));
      print(l.erorr);
    }, (r) {
      emit(AuthSuccess(r));
    });
  }

  void _authSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignIn(UserSignInParams(
      event.email,
      event.password,
    ));

    res.fold((l) {
      emit(AuthFail(l.erorr));
      print(l.erorr);
    }, (r) => _emitAuthSuccess(r, emit));
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    emit(AuthSuccess(user));
    _appUserCubit.updateUser(user);
  }
}
