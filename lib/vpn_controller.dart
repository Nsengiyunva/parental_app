import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VpnController extends ChangeNotifier {
  static const _platform = MethodChannel('parental_app/vpn');
  bool isRunning = false;

  Future<void> startVpn() async {
    try {
      final result = await _platform.invokeMethod('startVpn');
      if (result == true) {
        isRunning = true;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to start VPN: ${e.message}');
    }
  }

  Future<void> stopVpn() async {
    try {
      final result = await _platform.invokeMethod('stopVpn');
      if (result == true) {
        isRunning = false;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to stop VPN: ${e.message}');
    }
  }
}
