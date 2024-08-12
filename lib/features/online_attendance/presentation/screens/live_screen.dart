// import 'dart:convert';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'package:university_attendance/core/secrets/app_secrets.dart';

// class LiveScreen extends StatefulWidget {
//   final bool isBroadcaster;
//   final String channelId;
//   final String userId;

//   const LiveScreen({
//     Key? key,
//     required this.isBroadcaster,
//     required this.channelId,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   _LiveScreenState createState() => _LiveScreenState();
// }

// class _LiveScreenState extends State<LiveScreen> {
//   late final RtcEngine _engine;
//   int? _remoteUid;
//   bool isMuted = false;
//   String? token;

//   final String baseUrl =
//       "https://hotpink-porcupine-342704.hostingersite.com/php/sample/live_stream.php";

//   @override
//   void initState() {
//     super.initState();
//     _initializeEngine();
//   }

//   Future<void> _initializeEngine() async {
//     _engine = await createAgoraRtcEngine();

//     await _engine.initialize(const RtcEngineContext(
//       appId: AppSecrets.agoraAppId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));

//     _addListeners();

//     if (widget.isBroadcaster) {
//       await _engine.enableVideo();
//       await _engine.startPreview();
//     }

//     await _engine.setClientRole(
//       role: widget.isBroadcaster
//           ? ClientRoleType.clientRoleBroadcaster
//           : ClientRoleType.clientRoleAudience,
//     );

//     await _joinChannel();
//   }

//   Future<void> _joinChannel() async {
//     await _fetchToken();

//     if (defaultTargetPlatform == TargetPlatform.android) {
//       await [Permission.microphone, Permission.camera].request();
//     }

//     if (token != null) {
//       await _engine.joinChannel(
//         token: token!,
//         channelId: widget.channelId,
//         uid: 100,
//         options: ChannelMediaOptions(
//           autoSubscribeVideo: true,
//           autoSubscribeAudio: true,
//           publishCameraTrack: widget.isBroadcaster,
//           publishMicrophoneTrack: widget.isBroadcaster,
//           clientRoleType: widget.isBroadcaster
//               ? ClientRoleType.clientRoleBroadcaster
//               : ClientRoleType.clientRoleAudience,
//           audienceLatencyLevel:
//               AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
//         ),
//       );
//     } else {
//       debugPrint('Token is null, cannot join channel');
//     }
//   }

//   Future<void> _fetchToken() async {
//     final response = await http.post(Uri.parse(baseUrl), body: {
//       "channelname": widget.channelId,
//       "userid": widget.userId,
//     });

//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       setState(() {
//         token = jsonResponse['token'];
//       });
//     } else {
//       debugPrint('Failed to fetch the token');
//     }
//   }

//   void _addListeners() {
//     _engine.registerEventHandler(RtcEngineEventHandler(
//       onJoinChannelSuccess: (connection, elapsed) {
//         print("onJoinChannelSuccess: $connection, $elapsed");
//       },
//       onUserJoined: (connection, remoteUid, elapsed) {
//         print("onUserJoined: $connection, $remoteUid, $elapsed");
//         setState(() {
//           _remoteUid = remoteUid;
//         });
//       },
//       onUserOffline: (connection, remoteUid, reason) {
//         print("onUserOffline: $connection, $remoteUid, $reason");
//         setState(() {
//           if (_remoteUid == remoteUid) {
//             _remoteUid = null;
//           }
//         });
//       },
//       onLeaveChannel: (connection, stats) {
//         print("onLeaveChannel: $stats");
//         setState(() {
//           _remoteUid = null;
//         });
//       },
//       onTokenPrivilegeWillExpire: (connection, token) async {
//         print("onTokenPrivilegeWillExpire: $token");
//         await _fetchToken();
//         await _engine.renewToken(token);
//       },
//     ));
//   }

//   void _switchCamera() {
//     _engine.switchCamera().then((value) {
//       setState(() {
//         // Toggle switchCamera state
//       });
//     }).catchError((err) {
//       debugPrint('switchCamera $err');
//     });
//   }

//   void _toggleMute() async {
//     setState(() {
//       isMuted = !isMuted;
//     });
//     await _engine.muteLocalAudioStream(isMuted);
//   }

//   @override
//   void dispose() {
//     _engine.release();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         await _engine.leaveChannel();
//         return Future.value(true);
//       },
//       child: Scaffold(
//         bottomNavigationBar: widget.isBroadcaster
//             ? Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     await _engine.leaveChannel();
//                     Navigator.pop(context);
//                   },
//                   child: Text('End Stream'),
//                 ),
//               )
//             : null,
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: widget.isBroadcaster ? _remoteVideo() : _localVideo(),
//               ),
//               if (widget.isBroadcaster)
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.switch_camera),
//                       onPressed: _switchCamera,
//                     ),
//                     IconButton(
//                       icon: Icon(isMuted ? Icons.mic_off : Icons.mic),
//                       onPressed: _toggleMute,
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _remoteVideo() {
//     return AgoraVideoView(
//       controller: VideoViewController.remote(
//         rtcEngine: _engine,
//         canvas: VideoCanvas(uid: 50),
//         connection: RtcConnection(channelId: widget.channelId),
//       ),
//     );
//   }

//   Widget _localVideo() {
//     return AgoraVideoView(
//       controller: VideoViewController(
//         rtcEngine: _engine,
//         canvas: VideoCanvas(uid: 0),
//       ),
//     );
//   }
// }
