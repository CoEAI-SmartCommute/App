import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

class ShakeDetectorProvider with ChangeNotifier {
  ShakeDetector? _shakeDetector;
  VoidCallback? onShake;

  ShakeDetectorProvider() {
    _shakeDetector = ShakeDetector.autoStart(
      minimumShakeCount: 2,
      shakeThresholdGravity: 2 ,
      shakeCountResetTime: 1000,
      onPhoneShake: () {
        if (onShake != null) {
          onShake!();
        }
      },
    );
  }

  void setShakeCallback(VoidCallback callback) {
    onShake = callback;
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }
}
