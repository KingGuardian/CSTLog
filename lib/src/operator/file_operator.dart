import 'dart:io';

import 'package:cstlog/cstlog.dart';
import 'package:cstlog/src/constant/constant.dart';
import 'package:cstlog/src/loader/loader.dart';
import 'package:cstlog/src/model/log_info.dart';
import 'package:cstlog/src/operator/operator.dart';

class FileOperator implements Operator {
  final LogLoader _loader;

  FileOperator(this._loader);

  @override
  Future<String> exportDevelopLogTo(String path) async {
    String errorMessage = '';
    String newLogPath = path + Platform.pathSeparator + additelLogFolderName;
    try {
      await _createFolderIfNotExist(newLogPath);
    } catch(error) {
      errorMessage = error.toString();
      return errorMessage;
    }
    List<LogFileInfo> logList = await _loader.loadLogs();
    try {
      for (LogFileInfo logFileInfo in logList) {
        File file = File.fromUri(logFileInfo.uri);
        await file
            .copy(newLogPath + Platform.pathSeparator + logFileInfo.fileName);
      }
    } catch(error) {
      errorMessage = error.toString();
    }
    return errorMessage;
  }

  @override
  Future<String> exportRecordTo(String path) async {
    String errorMessage = '';
    String newRecordPath = path + Platform.pathSeparator + additelRecordFolderName;
    try {
      await _createFolderIfNotExist(newRecordPath);
    } catch(error) {
      errorMessage = error.toString();
      return errorMessage;
    }

    List<RecordInfo> recordList = await _loader.loadRecords();
    try {
      for (RecordInfo logFileInfo in recordList) {
        final uri = logFileInfo.uri;
        if (uri != null) {
          File file = File.fromUri(uri);
          String fileName = logFileInfo.fileName ?? logFileInfo.title;
          await file
              .copy(newRecordPath + Platform.pathSeparator + fileName);
        }
      }
    } catch(error) {
      errorMessage = error.toString();
    }
    return errorMessage;
  }

  _createFolderIfNotExist(String path) async {
    Directory director = Directory(path);
    if (!director.existsSync()) {
      await director.create(recursive: true);
    }
  }
}
