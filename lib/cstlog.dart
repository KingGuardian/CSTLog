import 'package:flutter/services.dart';

export 'package:cstlog/src/core/log.dart';
export 'package:cstlog/src/model/log_event.dart';
export 'package:cstlog/src/model/log_file_info.dart';
export 'package:cstlog/src/core/config.dart';

class Cstlog {
  static const MethodChannel _channel = MethodChannel('cstlog');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
