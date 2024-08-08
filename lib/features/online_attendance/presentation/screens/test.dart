import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:university_attendance/core/utils/navigation.dart';
import 'package:university_attendance/features/online_attendance/presentation/screens/white_board_screen.dart';

import '../../../../core/secrets/app_secrets.dart';

class OnlineSessionScreen extends StatefulWidget {
  final String channelId;
  final bool isBoadCaster;
  final String userId;
  const OnlineSessionScreen(
      {Key? key,
      required this.channelId,
      required this.userId,
      required this.isBoadCaster})
      : super(key: key);

  @override
  State<OnlineSessionScreen> createState() => _OnlineSessionScreenState();
}

class _OnlineSessionScreenState extends State<OnlineSessionScreen> {
  int? _remoteUid;
  String? token;
  bool isMuted = false;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  // CameraController? _controller;

  final String baseUrl =
      "https://hotpink-porcupine-342704.hostingersite.com/php/sample/live_stream.php";

  @override
  void initState() {
    super.initState();
    //  _initializeCamera();
    initAgora();
  }

  // Future<void> _initializeCamera() async {
  //   final cameras = await availableCameras();
  //   final frontCamera = cameras[0].lensDirection == CameraLensDirection.front
  //       ? cameras[0]
  //       : cameras[1];

  //   _controller = CameraController(frontCamera, ResolutionPreset.medium);
  //   await _controller!.initialize();

  //   setState(() {});
  // }

  Future<void> _fetchToken() async {
    final response = await http.post(Uri.parse(baseUrl), body: {
      "channelname": widget.channelId,
      "userid": widget.userId,
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        token = jsonResponse['token'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: AppSecrets.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire:
            (RtcConnection connection, String token) async {
          print("onTokenPrivilegeWillExpire: $token");
          await _fetchToken();
          await _engine.renewToken(token);
        },
      ),
    );

    await _engine.setClientRole(
        role: widget.isBoadCaster
            ? ClientRoleType.clientRoleBroadcaster
            : ClientRoleType.clientRoleAudience);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token:
          "007eJxTYLh1q/rR7L2+S3+tu6Lkq3VdYk2TWcO2uPN220s1gjeIrbRSYEixTExMSUo2MTEHYoOkxMQ0c/MUI4skEwML4xSTZEvOmUvSGgIZGU62TGdlZIBAEJ+FITUnv5iBAQDnvSE2",
      channelId: "elos",
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        // Toggle switchCamera state
      });
    }).catchError((err) {
      debugPrint('switchCamera $err');
    });
  }

  void _toggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }

  void _startScreenSharing() async {
    await _engine.startScreenCapture(
        const ScreenCaptureParameters2(captureAudio: true, captureVideo: true));
  }

  void _stopScreenSharing() async {
    await _engine.stopScreenCapture();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    navigationTo(
                        context,
                        FastboardExample(
                          userId: _remoteUid.toString(),
                        ));
                  },
                  child: Text("White board")),
              ElevatedButton(
                  onPressed: () {
                    _startScreenSharing();
                  },
                  child: Text("White board"))
            ],
          )

          // _controller != null && _controller!.value.isInitialized
          //     ? Opacity(
          //         opacity: 0.5,
          //         child: Align(
          //           alignment: Alignment.topLeft,
          //           child: SizedBox(
          //               width: 100,
          //               height: 150,
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     shape: BoxShape.circle,
          //                     color: const Color.fromARGB(96, 158, 158, 158)),
          //                 width: size.height / 3, // Adjust the width as needed
          //                 height:
          //                     size.height / 3, // Adjust the height as needed
          //                 child: Padding(
          //                   padding: EdgeInsets.all(size.width * 0.013),
          //                   child: ClipOval(
          //                     child: AspectRatio(
          //                       aspectRatio: 1 / 1,
          //                       child: CameraPreview(_controller!),
          //                     ),
          //                   ),
          //                 ),
          //               )),
          //         ),
          //       )
          //     : const CircularProgressIndicator(),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return Container(
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: const RtcConnection(channelId: "elos"),
          ),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
