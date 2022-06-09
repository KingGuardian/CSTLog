import 'dart:io';

import 'package:cstlog/cstlog.dart';
import 'package:cstlog/src/constant/constant.dart';
import 'package:cstlog/src/loader/loader.dart';
import 'package:cstlog/src/operator/operator.dart';

class FileOperator implements Operator {
  FileOperator();

  @override
  Future<String> exportDevelopLogTo(
      String path, List<LogFileInfo> logList) async {
    String errorMessage = '';
    String newLogPath = path + Platform.pathSeparator + additelLogFolderName;
    try {
      await _createFolderIfNotExist(newLogPath);
    } catch (error) {
      errorMessage = error.toString();
      return errorMessage;
    }
    try {
      for (LogFileInfo logFileInfo in logList) {
        File file = File.fromUri(logFileInfo.uri);
        await file.copy(newLogPath +
            Platform.pathSeparator +
            logFileInfo.fileName +
            '.log');
      }
    } catch (error) {
      errorMessage = error.toString();
    }
    return errorMessage;
  }

  @override
  Future<String> exportRecordTo(
      String path, List<RecordInfo> recordList) async {
    String errorMessage = '';
    String newRecordPath =
        path + Platform.pathSeparator + additelRecordFolderName;
    try {
      await _createFolderIfNotExist(newRecordPath);
    } catch (error) {
      errorMessage = error.toString();
      return errorMessage;
    }

    try {
      for (RecordInfo recordInfo in recordList) {
        final uri = recordInfo.uri;
        if (uri != null) {
          File file = File.fromUri(uri);
          String fileName = recordInfo.fileName ?? recordInfo.title;
          await file
              .copy(newRecordPath + Platform.pathSeparator + fileName + '.log');
        }
      }
    } catch (error) {
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
