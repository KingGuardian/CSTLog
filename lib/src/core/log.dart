import 'dart:io';

import 'package:cstlog/src/core/config.dart';
import 'package:cstlog/src/loader/loader.dart';
import 'package:cstlog/src/model/log_info.dart';
import 'package:cstlog/src/printer/printer.dart';
import 'package:cstlog/src/utils/default_factory.dart';

class CLog {
  // static final instance = CLog._init();
  final Printer _printer;
  final LogLoader _logLoader;
  final LogConfig _logConfig;

  CLog.init({LogConfig? config})
      : _logConfig = config ??= DefaultFactory.buildDefaultLogConfig(),
        _printer = DefaultFactory.buildDefaultPrinter(config),
        _logLoader = DefaultFactory.buildDefaultLogLoader(config);

  logToFile(String name, String content) {
    _printer.print(LogInfo(name, content));
  }

  Future<List<FileSystemEntity>> loadLogs() {
    return _logLoader.loadLogs();
  }

  loadLogsFromPath(String path) {}

  copyToFlashMemoryDisk() {}

  copyToFlashMemoryDiskFromPath(String path) {}
}
