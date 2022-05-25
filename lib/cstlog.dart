export 'package:cstlog/src/core/log.dart';

import 'package:flutter/services.dart';

class Cstlog {
  static const MethodChannel _channel = MethodChannel('cstlog');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
