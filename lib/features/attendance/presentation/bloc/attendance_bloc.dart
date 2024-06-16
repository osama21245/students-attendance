import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domin/usecases/check_wifi.dart';
part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final CheckWifiConnection _checkWifiConnection;
  AttendanceBloc({
    required CheckWifiConnection checkWifiConnection,
  })  : _checkWifiConnection = checkWifiConnection,
        super(AttendanceInitial()) {
    on<AttendanceCheckWifiConnection>(_checkwifiConnectionfun);
  }

  void _checkwifiConnectionfun(
    AttendanceCheckWifiConnection event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    final res = await _checkWifiConnection(NoParams());

    res.fold(
      (l) => emit(AttendanceFail(l.toString())),
      (r) => emit(AttendanceSuccess(r)),
    );
  }

  // void _emitAuthSuccess(String text, Emitter<AttendanceState> emit) {
  //   emit(AttendanceSuccess(text));
  //   _appUserCubit.updateUser(user);
  // }
}
