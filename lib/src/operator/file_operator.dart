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

    Directory director = Directory(path);
    if (!director.existsSync()) {
      director.createSync();
    }

    String newLogPath = path + Platform.pathSeparator + additelLogFolderName;
    director = Directory(newLogPath);
    if (!director.existsSync()) {
      director.createSync();
    }

    String newRecordPath =
        path + Platform.pathSeparator + additelRecordFolderName;
    List<LogFileInfo> logList = await _loader.loadLogs();
    List<LogFileInfo> recordList = await _loader.loadRecords();

    for (LogFileInfo logFileInfo in logList) {
      File file = File.fromUri(logFileInfo.uri);
      file.copySync(newLogPath + Platform.pathSeparator + logFileInfo.fileName);
    }

    for (LogFileInfo logFileInfo in recordList) {
      File file = File.fromUri(logFileInfo.uri);
      file.copySync(newRecordPath + Platform.pathSeparator + logFileInfo.fileName);
    }
    return true;
  }
}
