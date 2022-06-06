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
      FileUtil.instantce.writeContentTo(logFile, message);
      //打印时间戳
      FileUtil.instantce.writeContentTo(logFile, DateTime.now().toString());
      FileUtil.instantce.writeContentTo(logFile, errorMessage);
      FileUtil.instantce.writeContentTo(logFile, traceMessage + '\n\n\n\n');
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

  Future<File?> _initFileByEvent(bool isLog, {LogEvent? logEvent, RecordInfo? recordInfo}) async {
    String? storagePath = isLog ? await _getLogStoragePath() : await _getRecordStoragePath();
    if (storagePath == null) {
      //可能平台不支持，这里的错误提示还需要细化，看是否返回一个error
      return null;
    }
    Directory storateDir = Directory(storagePath);
    if (!storateDir.existsSync()) {
      storateDir.createSync(recursive: true);
    }

    String fileName = isLog
        ? _fileConfig.fileNameStrategy.generateLogFileName(logEvent!)
        : _fileConfig.fileNameStrategy.generateRecordFileName(recordInfo!);
    String filePath = storagePath + Platform.pathSeparator + fileName;

    File recordFile = File(filePath);
    if (!recordFile.existsSync()) {
      recordFile.createSync();
      return recordFile;
    } else {
      //根据策略判断是否要新建文件
      if (_fileConfig.fileSplitStrategy.isNeedCreateNewFile(recordFile)) {
        //新建文件的名字处理，暂时没想到什么好方法，就先按顺序查一下文件是否存在吧
        int extraFileTail = 1;
        List<String> strList = fileName.split('.');
        String newFileName = strList[0] + '_' + '$extraFileTail' + strList[1];
        File newFile = File(newFileName);
        while (newFile.existsSync() &&
            _fileConfig.fileSplitStrategy.isNeedCreateNewFile(newFile)) {
          extraFileTail++;
          newFileName = strList[0] + '_' + '$extraFileTail' + strList[1];
          newFile = File(newFileName);
        }
        return newFile;
      } else {
        return recordFile;
      }
    }
  }

  Future<String?> _getLogStoragePath() async {
    return _getTargetStoragePath(_fileConfig.logFolderName);
  }

  Future<String?> _getRecordStoragePath() async {
    return _getTargetStoragePath(_fileConfig.recordFolderName);
  }

  Future<String?> _getTargetStoragePath(String folderName) async {
    Directory? storageDirectory = await _getDeviceStoragePath();
    String? path = storageDirectory != null
        ? storageDirectory.path + Platform.pathSeparator + folderName
        : null;
    return path;
  }

  Future<Directory?> _getDeviceStoragePath() async {
    Directory? storageDirectory;
    switch (_fileConfig.storageType) {
      case LogStorageType.applicationSupport:
        storageDirectory = await getApplicationSupportDirectory();
        break;
      case LogStorageType.applicationDoucument:
        storageDirectory = await getApplicationDocumentsDirectory();
        break;
      case LogStorageType.externalStorage:
        storageDirectory = await getExternalStorageDirectory();
        break;
      default:
        break;
    }
    return storageDirectory;
  }

  String? _formatTraceMessage(StackTrace? stackTrace) {
    int maxLines = 10;
    var lines = stackTrace.toString().split('\n');
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
}
