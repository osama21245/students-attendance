// import 'package:flutter/material.dart';
// import 'package:fastboard_flutter/fastboard_flutter.dart';
// import 'package:university_attendance/core/common/class/white_board.dart';
// import 'package:university_attendance/core/secrets/app_secrets.dart';

// class FastboardExample extends StatefulWidget {
//   final String userId;

//   const FastboardExample({super.key, required this.userId});
//   @override
//   _FastboardExampleState createState() => _FastboardExampleState();
// }

// class _FastboardExampleState extends State<FastboardExample> {
//   String? token;
//   String? roomId;

//   void getdataOfRoom() async {
//     final res = await createRoom();
//     token = res["token"];
//     roomId = res["room_uuid"];
//     setState(() {});
//   }

//   void initState() {
//     super.initState();
//     getdataOfRoom();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fastboard Example'),
//       ),
//       body: token == null || roomId == null
//           ? Center(child: CircularProgressIndicator())
//           : FastboardView(
//               userId: widget.userId,
//               roomId: roomId!,
//               token: token!,
//             ),
//     );
//   }
// }

// class FastboardView extends StatelessWidget {
//   final String roomId;
//   final String token;
//   final String userId;
//   const FastboardView(
//       {super.key,
//       required this.roomId,
//       required this.token,
//       required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return FastRoomView(
//       fastRoomOptions: FastRoomOptions(
//         appId: AppSecrets.whiteBoardAppId,
//         uuid: roomId,
//         token: token,
//         uid: userId,
//         writable: true,
//         fastRegion: FastRegion.us_sv,
//       ),
//       theme: FastThemeData.light(),
//       darkTheme: FastThemeData.dark(),
//     );
//   }
// }
