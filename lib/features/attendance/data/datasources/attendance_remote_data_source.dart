import 'package:network_info_plus/network_info_plus.dart';
import '../../../../core/erorr/exception.dart';

abstract interface class AttendanceRemoteDataSource {
  Future<String> checkWifiConnection();
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  AttendanceRemoteDataSourceImpl();

  @override
  Future<String> checkWifiConnection() async {
    final info = NetworkInfo();
    String? bssid;
    try {
      bssid = await info.getWifiIP(); // الحصول على BSSID
      print(bssid);

      if (bssid == null) {
        throw "erorr in connection";
      } else {
        return bssid;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Future<UserModel> logInWithEmailAndPassword(
  //     {required String email, required String password}) async {
  // try {
  //   final response = await supabaseClient.auth
  //       .signInWithPassword(email: email, password: password);
  //   if (response.user == null) {
  //     throw ServerException("Email or Passowrd is wrong");
  //   } else {
  //     return UserModel.fromJson(response.user!.toJson())
  //         .copyWith(email: currentUserSession!.user.email);
  //   }
  // } catch (e) {
  //   throw ServerException(e.toString());
  // }
  // }
}
