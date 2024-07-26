import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:university_attendance/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class FaceDetect extends StatefulWidget {
  const FaceDetect({super.key});

  @override
  State<FaceDetect> createState() => _FaceDetectState();
}

class _FaceDetectState extends State<FaceDetect> {
  final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true);
  //File? _image;
  InputImage? visionImage;
  late FaceDetector faceDetector;
  //List<Face>? faces;
  double? result;
  String? capImage;

  File? _image;

  List<Face> faces = [];
  //late Timer _timer;

  @override
  void initState() {
    super.initState();
    faceDetector = FaceDetector(options: options);
  }

  Future<File> _processImage(File image) async {
    final bytes = await image.readAsBytes();
    // تغيير حجم الصورة إلى دقة قياسية
    final imageResized = img.decodeImage(bytes)!;
    final imageNormalized =
        img.copyResize(imageResized, width: 480, height: 640);

    // حفظ الصورة المعالجة في ملف مؤقت
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/processed_image.jpg');
    await tempFile.writeAsBytes(img.encodeJpg(imageNormalized));

    return tempFile;
  }

  Future<void> _getImage() async {
    final pickedFile =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // _image = await _processImage(_image!);
      // visionImage = InputImage.fromFile(_image!);

      await sendImageToServer(_image!);
    }
  }

  Future<void> _detectFaces() async {
    if (visionImage != null) {
      final detectedFaces = await faceDetector.processImage(visionImage!);

      setState(() {
        faces = detectedFaces;
        // final faceData = faces.first;
      });

      if (faces.isNotEmpty) {
        await _registerFace();
      }
    }
  }

  Future<void> sendImageToServer(File imageFile) async {
    final url = Uri.parse('https://bee4-156-217-187-128.ngrok-free.app/submit');
    var request = http.MultipartRequest('POST', url)
      ..fields['name'] = "osama_elpop" // إضافة الاسم كحقل نصي
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);
      setState(() {
        capImage = decodedResponse['response'];
      });
    } else {}
  }

  Future<void> _registerFace() async {
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Face registered successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            child: Text("=======$result"),
          ),
          AuthGradientButton(
              buttonText: "test",
              onPressed: () {
                _getImage();
              }),
        ],
      )),
    );
  }
}
