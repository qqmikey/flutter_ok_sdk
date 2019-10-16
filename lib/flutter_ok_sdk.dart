import 'dart:async';

import 'package:flutter/services.dart';

class FlutterOkSdk {
  static const MethodChannel _channel = const MethodChannel('flutter_ok_sdk');

  static Future<OkToken> login() async {
    final _userData = await _channel.invokeMethod('login');
    final userData = new Map<String, dynamic>.from(_userData);
    return OkToken(userData['access_token'], userData['secret']);
  }
}

class OkToken {
  final String token;
  final String secret;

  OkToken(this.token, this.secret);
}
