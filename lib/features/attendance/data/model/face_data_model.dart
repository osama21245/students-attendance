class FaceData {
  final List<Map<String, dynamic?>> landmarks;
  final List<double> headEulerAngleY;
  final List<double> headEulerAngleZ;
  final List<double> leftEyeOpenProbability;
  final List<double> rightEyeOpenProbability;
  final List<double> smilingProbability;

  FaceData({
    required this.landmarks,
    required this.headEulerAngleY,
    required this.headEulerAngleZ,
    required this.leftEyeOpenProbability,
    required this.rightEyeOpenProbability,
    required this.smilingProbability,
  });

  Map<String, dynamic> toMap() {
    return {
      'landmarks': landmarks,
      'headEulerAngleY': headEulerAngleY,
      'headEulerAngleZ': headEulerAngleZ,
      'leftEyeOpenProbability': leftEyeOpenProbability,
      'rightEyeOpenProbability': rightEyeOpenProbability,
      'smilingProbability': smilingProbability,
    };
  }

  static FaceData fromMap(Map<String, dynamic> map) {
    return FaceData(
      landmarks: List<Map<String, dynamic>>.from(map['landmarks']),
      headEulerAngleY: List<double>.from(map['headEulerAngleY']),
      headEulerAngleZ: List<double>.from(map['headEulerAngleZ']),
      leftEyeOpenProbability: List<double>.from(map['leftEyeOpenProbability']),
      rightEyeOpenProbability:
          List<double>.from(map['rightEyeOpenProbability']),
      smilingProbability: List<double>.from(map['smilingProbability']),
    );
  }
}
