import 'dart:io';

import 'package:cstlog/src/model/log_info.dart';

abstract class FileNameStrategy {
  String generateFileName(LogInfo logInfo);
}

class DefaultFileNameStrategy implements FileNameStrategy {
  @override
  String generateFileName(LogInfo logInfo) {
    String fileName = logInfo.name.isEmpty ? "CSTLog" : logInfo.name;
    String fileTail = Platform.isIOS ? ".text" : ".txt";
    DateTime dateTime = DateTime.now();
    fileName =
        fileName + "_ ${dateTime.year} _ ${dateTime.month} _ ${dateTime.day}" + fileTail;
    return fileName;
  }
}
