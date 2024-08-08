import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:university_attendance/core/usecase/usecase.dart';
import 'package:university_attendance/features/attendance/domin/entities/session.dart';
import 'package:university_attendance/features/attendance/domin/usecases/check_stud_face_model.dart';
import 'package:university_attendance/features/attendance/domin/usecases/confirm_attendance.dart';
import 'package:university_attendance/features/attendance/domin/usecases/get_local_attendance.dart';
import 'package:university_attendance/features/attendance/domin/usecases/get_local_photos.dart';
import 'package:university_attendance/features/attendance/domin/usecases/sessions/get_sessions.dart';
import 'package:university_attendance/features/attendance/domin/usecases/set_local_photos.dart';
import '../../domin/entities/attendance.dart';
import '../../domin/usecases/confirm_qualifications.dart';
import '../../domin/usecases/set_local_attendance.dart';
part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final ConfirmAttendance _confirmAttendance;
  final ConfirmQualifications _confirmQualifications;
  final CheckStudFace _checkStudFace;
  final GetSessions _getSessions;
  final GetLocalPhotos _getLocalPhotos;
  final SetLocalPhotos _setLocalPhotos;
  final GetLocalAttendance _getLocalAttendance;
  final SetLocalAttendance _setLocalAttendance;
  AttendanceBloc({
    required ConfirmQualifications confirmQualifications,
    required ConfirmAttendance confirmAttendance,
    required CheckStudFace checkStudFace,
    required GetSessions getSessions,
    required GetLocalPhotos getLocalPhotos,
    required SetLocalPhotos setLocalPhotos,
    required GetLocalAttendance getLocalAttendance,
    required SetLocalAttendance setLocalAttendance,
  })  : _confirmAttendance = confirmAttendance,
        _confirmQualifications = confirmQualifications,
        _checkStudFace = checkStudFace,
        _getSessions = getSessions,
        _getLocalPhotos = getLocalPhotos,
        _setLocalPhotos = setLocalPhotos,
        _getLocalAttendance = getLocalAttendance,
        _setLocalAttendance = setLocalAttendance,
        super(AttendanceInitial()) {
    on<AttendanceConfirmAttendance>(_confirmAttendancefun);
    on<AttendanceConfirmQualifications>(_confirmAttendanceQualifications);
    on<AttendanceCheckStudFace>(_checkStudFaceFun);
    on<AttendanceGetSessions>(_getSessionsFun);
    on<AttendanceGetLocalAttendance>(_getLocalAttendanceFun);
    on<AttendanceSetLocalAttendance>(_setLocalAttendanceFun);
    on<AttendanceGetLocalPhotos>(_getLocalPhotosFun);
    on<AttendanceSetLocalPhotos>(_setLocalPhotosFun);
    on<AttendanceStartLoading>(_loading);
    on<AttendanceStopLoading>(_stopLoading);
  }

  void _confirmAttendancefun(
    AttendanceConfirmAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    final res = await _confirmAttendance(ConfirmAttendanceParams(
        sessionId: event.sessionId, userId: event.userId));

    res.fold(
      (l) => emit(AttendanceFail(l.toString())),
      (r) {
        if (r["status"] == "success") {
          emit(AttendanceSuccess(r));
        } else {
          emit(AttendanceFail("fail"));
        }
      },
    );
  }

  void _confirmAttendanceQualifications(
    AttendanceConfirmQualifications event,
    Emitter<AttendanceState> emit,
  ) async {
    final res = await _confirmQualifications(ConfirmQualificationsParams(
        attendBssid: event.attendbssid,
        attendLat: event.attendLat,
        attendLong: event.attendLong,
        attendDistance: event.attendDistance));

    res.fold(
      (l) => emit(AttendanceRejectQualifications(l.toString())),
      (r) {
        if (r) {
          emit(AttendanceConfirmQualificationsSucess(isQualified: r));
        } else {
          emit(AttendanceRejectQualifications("Check your Lecture or Wifi"));
        }
      },
    );
  }

  void _checkStudFaceFun(
      AttendanceCheckStudFace event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    final res = await _checkStudFace(
        CheckStudFaceModelParams(file: event.image, stdId: event.studId));

    res.fold((l) {
      emit(AttendanceFail(l.erorr));
    }, (r) {
      print(r.state);
      if (r.state == "success") {
        print("done ${r.data}");
        emit(AttendanceCheckFaceSuccess(similarty: r.data));
      } else {
        emit(AttendanceFail(r.state.toString()));
      }
    });
  }

  //sessions

  _getSessionsFun(
      AttendanceGetSessions event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    final res =
        await _getSessions(GetSessionsParams(collageId: event.collageId));
    res.fold((l) => emit(AttendanceFail(l.toString())),
        (r) => emit(AttendanceGetSessionsSuccess(sessions: r)));
  }

  // local database

  void _getLocalAttendanceFun(
      AttendanceGetLocalAttendance event, Emitter<AttendanceState> emit) async {
    final res = await _getLocalAttendance(NoParams());
    res.fold((l) => emit(AttendanceFail(l.toString())),
        (r) => emit(AttendanceGetLocalAttendanceSuccess(attendance: r)));
  }

  void _setLocalAttendanceFun(
      AttendanceSetLocalAttendance event, Emitter<AttendanceState> emit) async {
    final res = await _setLocalAttendance(SetLocalAttendanceParams(
        sessionId: event.sessionId, userId: event.userId));
    res.fold((l) => emit(AttendanceFail(l.toString())),
        (r) => emit(AttendanceSetLocalAttendanceSuccess()));
  }

  void _getLocalPhotosFun(
      AttendanceGetLocalPhotos event, Emitter<AttendanceState> emit) async {
    final res = await _getLocalPhotos(NoParams());
    res.fold((l) => emit(AttendanceFail(l.toString())),
        (r) => emit(AttendanceGetLocalPhotosSuccess(file: r)));
  }

  void _setLocalPhotosFun(
      AttendanceSetLocalPhotos event, Emitter<AttendanceState> emit) async {
    final res = await _setLocalPhotos(SetLocalPhotosParams(file: event.file));
    res.fold((l) => emit(AttendanceFail(l.toString())),
        (r) => emit(AttendanceSetLocalPhotosSuccess()));
  }

  void _loading(AttendanceStartLoading event, Emitter<AttendanceState> emit) {
    emit(AttendanceLoading());
  }

  void _stopLoading(
      AttendanceStopLoading event, Emitter<AttendanceState> emit) {
    emit(AttendanceStopLoadingState());
  }
}
