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

  /// 记录维修日志
  Future<String> record(String name, String content, String operatorName, String date) async {
    return await _printer.record(RecordInfo(name, content, operatorName, date));
  }

  /// 记录开发日志
  Future<String> log(Level level, String message, [dynamic error, StackTrace? stackTrace]) async {
    return await _printer.log(LogEvent(level, message, error, stackTrace));
  }

  /// 获取维修日志
  Future<List<RecordInfo>> loadRecords() {
    return _loader.loadRecords();
  }

  /// 获取开发日志
  Future<List<LogFileInfo>> loadLogs() {
    return _loader.loadLogs();
  }

  /// 导出开发日志到路径
  Future<String> exportLogs(String path) async {
    _operator ??= FileOperator(_loader);
    String errorMessage = await _operator?.exportDevelopLogTo(path) ?? '';
    return errorMessage;
  }

  /// 导出维修日志到路径
  Future<String> exportRecords(String path) async {
    _operator ??= FileOperator(_loader);
    String errorMessage = await _operator?.exportRecordTo(path) ?? '';
    return errorMessage;
  }
}
