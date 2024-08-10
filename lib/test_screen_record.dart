import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenRecorder {
  static const MethodChannel _channel =
      MethodChannel('com.example/screen_record');

  static Future<String> startRecording() async {
    try {
      final String result = await _channel.invokeMethod('startRecording');
      return result;
    } on PlatformException catch (e) {
      return "Failed to start recording: '${e.message}'";
    }
  }

  static Future<String> stopRecording() async {
    try {
      final String result = await _channel.invokeMethod('stopRecording');
      return result;
    } on PlatformException catch (e) {
      return "Failed to stop recording: '${e.message}'";
    }
  }
}

class TestScreenRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                String result = await ScreenRecorder.startRecording();
                print(result);
              },
              child: Text('Start Recording'),
            ),
            ElevatedButton(
              onPressed: () async {
                String result = await ScreenRecorder.stopRecording();
                print(result);
              },
              child: Text('Stop Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
