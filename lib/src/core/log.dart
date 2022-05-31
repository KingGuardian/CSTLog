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
  final LogConfig _logConfig;
  Operator? _operator;

  Logger.init({LogConfig? config})
      : _logConfig = config ??= DefaultFactory.buildDefaultLogConfig(),
        _printer = DefaultFactory.buildDefaultPrinter(config),
        _loader = DefaultFactory.buildDefaultLogLoader(config);

  Future<void> record(String name, String content) async {
    _printer.record(RecordInfo(name, content));
  }

  Future<void> log(Level level, String message, [dynamic error, StackTrace? stackTrace]) async {
    _printer.log(LogEvent(level, message, error, stackTrace));
  }

  Future<List<LogFileInfo>> loadRecords() {
    return _loader.loadRecords();
  }

  Future<List<LogFileInfo>> loadLogs() {
    return _loader.loadLogs();
  }

  // loadLogsFromPath(String path) {}

  // copyToFlashMemoryDisk() {}

  Future<void> copyToFlashMemoryDiskFromPath(String path) async {
    _operator ??= FileOperator(_loader);
    _operator?.copyFilesTo(path);
  }
}
