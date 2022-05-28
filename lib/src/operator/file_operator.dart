import 'dart:io';

import 'package:cstlog/cstlog.dart';
import 'package:cstlog/src/constant/constant.dart';
import 'package:cstlog/src/loader/loader.dart';
import 'package:cstlog/src/operator/operator.dart';

class FileOperator implements Operator {
  final LogLoader _loader;

  FileOperator(this._loader);

  @override
  Future<bool> copyFilesTo(String path) async {
    String newLogPath = path + Platform.pathSeparator + additelLogFolderName;
    await _createFolderIfNotExist(newLogPath);

    String newRecordPath =
        path + Platform.pathSeparator + additelRecordFolderName;
    await _createFolderIfNotExist(newRecordPath);

    List<LogFileInfo> logList = await _loader.loadLogs();
    List<LogFileInfo> recordList = await _loader.loadRecords();

    for (LogFileInfo logFileInfo in logList) {
      File file = File.fromUri(logFileInfo.uri);
      await file
          .copy(newLogPath + Platform.pathSeparator + logFileInfo.fileName);
    }

    for (LogFileInfo logFileInfo in recordList) {
      File file = File.fromUri(logFileInfo.uri);
      await file
          .copy(newRecordPath + Platform.pathSeparator + logFileInfo.fileName);
    }
    return true;
  }

  _createFolderIfNotExist(String path) async {
    Directory director = Directory(path);
    if (!director.existsSync()) {
      await director.create(recursive: true);
    }
  }
}
