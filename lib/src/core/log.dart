import 'package:cstlog/src/core/config.dart';
import 'package:cstlog/src/loader/loader.dart';
import 'package:cstlog/src/model/log_event.dart';
import 'package:cstlog/src/model/log_file_info.dart';
import 'package:cstlog/src/model/log_info.dart';
import 'package:cstlog/src/operator/file_operator.dart';
import 'package:cstlog/src/operator/operator.dart';
import 'package:cstlog/src/printer/printer.dart';
import 'package:cstlog/src/utils/default_factory.dart';

/// 记录开发中的log和维修日志的工具类
/// API中的record代表维修日志，log代表开发日志
class Logger {
  final Printer _printer;
  final LogLoader _loader;
  Operator? _operator;

  Logger.init({LogConfig? config})
      : _printer = DefaultFactory.buildDefaultPrinter(config),
        _loader = DefaultFactory.buildDefaultLogLoader(config);

  record(String name, String content) {
    _printer.record(RecordInfo(name, content));
  }

  log(Level level, String message, [dynamic error, StackTrace? stackTrace]) {
    _printer.log(LogEvent(level, message, error, stackTrace));
  }

  Future<List<LogFileInfo>> loadRecords() {
    return _loader.loadRecords();
  }

  Future<List<LogFileInfo>> loadLogs() {
    return _loader.loadLogs();
  }

  copyToFlashMemoryDiskFromPath(String path) {
    _operator ??= FileOperator(_loader);
    _operator?.copyFilesTo(path);
  }
}
