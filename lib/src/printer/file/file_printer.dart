import 'dart:io';

import 'package:cstlog/src/model/log_event.dart';
import 'package:cstlog/src/model/log_info.dart';
import 'package:cstlog/src/printer/file/file_config.dart';
import 'package:cstlog/src/printer/file/size_strategy.dart';
import 'package:cstlog/src/printer/printer.dart';
import 'package:cstlog/src/utils/file_utils.dart';

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

      // 调整顺序，新写入的日志在文件前
      String content = '--------  ' +
          dateTime +
          '  --------' +
          '\n' +
          message +
          '\n' +
          errorMessage +
          '\n' +
          traceMessage +
          '\n';
      await FileUtil.instantce.writeContentTo(
        logFile,
        content,
        isAppend: false,
      );
    } catch (error) {
      operatorErrorMessage = error.toString();
    }
    return operatorErrorMessage;
  }

  @override
  Future<String> record(RecordInfo recordInfo) async {
    String operatorErrorMessage = '';
    if (!recordInfo.isSizeValid()) {
      operatorErrorMessage = '文件内容过大';
      return operatorErrorMessage;
    }
    //单次写入大小暂时还没有限制，需要完善策略
    File? logFile = await _initFileByEvent(false, recordInfo: recordInfo);
    if (logFile == null) {
      operatorErrorMessage = '创建日志文件失败';
      return operatorErrorMessage;
    }

    try {
      //维修记录和日志不同，使用覆盖方式，因为要从文件内容中读取到存储的信息
      await FileUtil.instantce.writeContentTo(
        logFile,
        recordInfo.getWriteContent(),
        mode: FileMode.write,
      );
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
    String filePath = storagePath + Platform.pathSeparator + defaultFileName;
    File recordFile = File(filePath);

    if (logEvent != null) {
      //目前只有系统日志需要执行拆分操作，同样，命名规则也应该只有日志才需要加文件后缀编号
      int fileIndex = 0;
      String fileName = getFileNameWithIndex(defaultFileName, fileIndex);
      filePath = storagePath + Platform.pathSeparator + fileName;
      recordFile = File(filePath);
      //判断文件是否需要拆分
      while (recordFile.existsSync() &&
          _fileConfig.fileSplitStrategy.isNeedCreateNewFile(recordFile)) {
        fileIndex++;
        fileName = getFileNameWithIndex(defaultFileName, fileIndex);
        filePath = storagePath + Platform.pathSeparator + fileName;
        recordFile = File(filePath);
      }
    }
    if (!recordFile.existsSync()) {
      //创建新文件时，检查一下当前缓存空间状态
      final sizeStrategy = FifoStrategy(_fileConfig, isLog);
      final isNeedClear = await sizeStrategy.isNeedClearCache();
      if (isNeedClear) {
        await sizeStrategy.clearCache();
      }
      //先执行删除，再创建文件
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
    Directory? storageDirectory =
        await FileUtil.instantce.getDeviceStoragePath(_fileConfig.storageType);
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
