import 'dart:io';

import 'package:cstlog/src/core/config.dart';
import 'package:cstlog/src/model/log_event.dart';
import 'package:cstlog/src/model/log_info.dart';
import 'package:cstlog/src/printer/file/file_config.dart';
import 'package:cstlog/src/printer/printer.dart';
import 'package:cstlog/src/utils/file_utils.dart';
import 'package:path_provider/path_provider.dart';

class FilePrinter implements Printer {
  final FilePrinterConfig _fileConfig;

  FilePrinter(this._fileConfig);

  @override
  Future<String> log(LogEvent logEvent) async {
    String message = logEvent.message;
    String errorMessage = logEvent.error?.toString() ?? '';
    String traceMessage = _formatTraceMessage(logEvent.stackTrace) ?? '';

    String operatorErrorMessage = '';

    //单次写入大小暂时还没有限制，需要完善策略
    File? logFile = await _initFileByEvent(true, logEvent: logEvent);
    if (logFile == null) {
      operatorErrorMessage = '创建日志文件失败';
      return operatorErrorMessage;
    }

    try {
      //打印时间戳
      String dateTime = getDateTime();
      FileUtil.instantce
          .writeContentTo(logFile, '--------  ' + dateTime + '  --------');
      FileUtil.instantce.writeContentTo(logFile, message);
      FileUtil.instantce.writeContentTo(logFile, errorMessage);
      FileUtil.instantce.writeContentTo(logFile, traceMessage + '\n');
    } catch (error) {
      operatorErrorMessage = error.toString();
    }
    return operatorErrorMessage;
  }

  @override
  Future<String> record(RecordInfo recordInfo) async {
    String operatorErrorMessage = '';
    //单次写入大小暂时还没有限制，需要完善策略
    File? logFile = await _initFileByEvent(false, recordInfo: recordInfo);
    if (logFile == null) {
      operatorErrorMessage = '创建日志文件失败';
      return operatorErrorMessage;
    }

    try {
      FileUtil.instantce.writeContentTo(logFile, recordInfo.content);
    } catch (error) {
      operatorErrorMessage = error.toString();
    }
    return operatorErrorMessage;
  }

  Future<File?> _initFileByEvent(bool isLog,
      {LogEvent? logEvent, RecordInfo? recordInfo}) async {
    String? storagePath =
        isLog ? await _getLogStoragePath() : await _getRecordStoragePath();
    if (storagePath == null) {
      //可能平台不支持，这里的错误提示还需要细化，看是否返回一个error
      return null;
    }
    Directory storateDir = Directory(storagePath);
    if (!storateDir.existsSync()) {
      storateDir.createSync(recursive: true);
    }

    String defaultFileName = isLog
        ? _fileConfig.fileNameStrategy.generateLogFileName(logEvent!)
        : _fileConfig.fileNameStrategy.generateRecordFileName(recordInfo!);

    int fileIndex = 0;
    String fileName = getFileNameWithIndex(defaultFileName, fileIndex);
    String filePath = storagePath + Platform.pathSeparator + fileName;
    File recordFile = File(filePath);
    //判断文件是否需要拆分
    while (recordFile.existsSync() &&
        _fileConfig.fileSplitStrategy.isNeedCreateNewFile(recordFile)) {
      fileIndex++;
      fileName = getFileNameWithIndex(defaultFileName, fileIndex);
      filePath = storagePath + Platform.pathSeparator + fileName;
      recordFile = File(filePath);
    }
    if (!recordFile.existsSync()) {
      recordFile.createSync();
    }
    return recordFile;
  }

  Future<String?> _getLogStoragePath() async {
    return _getTargetStoragePath(_fileConfig.logFolderName);
  }

  Future<String?> _getRecordStoragePath() async {
    return _getTargetStoragePath(_fileConfig.recordFolderName);
  }

  Future<String?> _getTargetStoragePath(String folderName) async {
    Directory? storageDirectory = await FileUtil.instantce.getDeviceStoragePath(_fileConfig.storageType);
    String? path = storageDirectory != null
        ? storageDirectory.path + Platform.pathSeparator + folderName
        : null;
    return path;
  }

  String? _formatTraceMessage(StackTrace? stackTrace) {
    String stackContent = stackTrace?.toString() ?? "";
    if (stackContent.isEmpty) {
      return '\n';
    }

    int maxLines = 15;
    var lines = stackContent.split('\n');
    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
      count++;
      if (count == maxLines) {
        break;
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  String getDateTime() {
    String dateStr = DateTime.now().toString();
    dateStr = dateStr.split('.')[0];
    return dateStr;
  }

  String getFileNameWithIndex(String fileName, int index) {
    final fileNameList = fileName.split('.');
    return fileNameList[0] + '-' + index.toString() + '.' + fileNameList[1];
  }
}
