import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:university_attendance/core/common/widget/loader.dart';
import 'package:university_attendance/core/theme/app_pallete.dart';
import 'package:university_attendance/core/utils/show_snack_bar.dart';
import 'package:university_attendance/features/attendance/presentation/pages/face_detaction_scree.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/check_face_in_photo.dart';
import '../bloc/auth_bloc.dart';

class FaceCaptureScreen extends StatefulWidget {
  @override
  _FaceCaptureScreenState createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  CameraController? _controller;
  List<File> _images = [];
  List<File> _acceptedImages = [];
  bool faceInBox = false;
  File? captureImage;
  File? checkFaceInBoxImage;
  Uuid uuid = Uuid();

  late Timer _timer;
  int _photoCount = 0;
  final int _maxPhotos = 10; // يمكن تعديل العدد المناسب
  bool _isTakingPhotos = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _checkFaceInCircle();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras[0].lensDirection == CameraLensDirection.front
        ? cameras[0]
        : cameras[1];

    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    await _controller!.initialize();

    setState(() {});
  }

  void _checkFaceInCircle() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final xFile = await _controller!.takePicture();
      final imagePath = xFile.path;
      final imageFile = File(imagePath);
      checkFaceInBoxImage = imageFile;
      if (await checkFaceInPhotoToUser(checkFaceInBoxImage!, context)) {
        faceInBox = true;
      } else {
        faceInBox = false;
      }
      setState(() {});
    });
  }

  void _startTakingPhotos() {
    setState(() {
      _timer.cancel();
      _isTakingPhotos = true;
    });

    if (_controller != null &&
        _controller!.value.isInitialized &&
        _photoCount < _maxPhotos) {
      _takePicture();
    }
  }

  void _stopTakingPhotos() {
    _timer.cancel();
    setState(() {
      _isTakingPhotos = true;
    });
  }

  Future<void> _takePicture() async {
    final xFile = await _controller!.takePicture();
    final imagePath = xFile.path;
    final imageFile = File(imagePath);
    captureImage = imageFile;

    if (await checkFaceInPhoto(captureImage!, context)) {
      _images.add(captureImage!);
      setState(() {});
      if (_images.length == 10) {
        _isTakingPhotos = false;
        context
            .read<AuthBloc>()
            .add(AuthSetStudFaceModel(image: _images, studId: "listOsama"));
      } else {
        _startTakingPhotos();
      }
    } else {
      faceInBox = false;
      _isTakingPhotos = false;
      _images.clear();
      _checkFaceInCircle();
      showSnackBar(context, "Please set your head in the frame");
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => FaceDetect())),
            child: Text(
              _images.length.toString(),
            ),
          ),
          SizedBox(
            width: 60,
          )
        ],
        title: Text('Face Capture'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSetModelSuccess) {
            showSnackBar(context, "sucess");
            _acceptedImages.add(captureImage!);
          } else if (state is AuthFail) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _controller != null && _controller!.value.isInitialized
                    ? Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: faceInBox
                                ? AppPallete.primaryColor
                                : Color.fromARGB(95, 246, 129, 120)),
                        width: size.height / 3, // Adjust the width as needed
                        height: size.height / 3, // Adjust the height as needed
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.013),
                          child: ClipOval(
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: CameraPreview(_controller!),
                            ),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
                const SizedBox(height: 10),
                _isTakingPhotos
                    ? Column(
                        children: [
                          Container(height: size.height * 0.4, child: Loader()),
                          Text("Please don't move your face"),
                        ],
                      )
                    : AnimatedOpacity(
                        opacity: faceInBox ? 1 : 0,
                        duration: Duration(seconds: 1),
                        child: ElevatedButton(
                          onPressed: faceInBox ? _startTakingPhotos : () {},
                          child: const Text('Start Taking Photos'),
                        )),

                // Expanded(
                //   child: ListView.builder(
                //     itemCount: _acceptedImages.length,
                //     itemBuilder: (context, index) {
                //       return Image.file(_acceptedImages[index]);
                //     },
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
