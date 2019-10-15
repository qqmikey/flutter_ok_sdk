import 'dart:async';

import 'package:flutter/services.dart';

class FlutterOkSdk {
  static const MethodChannel _channel = const MethodChannel('flutter_ok_sdk');

  static Future<String> login() async {
    final String version = await _channel.invokeMethod('login');
    return version;
  }
}
