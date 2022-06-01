import 'dart:io';

import 'package:cstlog/src/model/log_file_info.dart';

class FileUtil {

  static final FileUtil instantce = FileUtil._();

  FileUtil._();

  // bool checkFolderExist(String path, {bool create = false}) {
  //   return false;
  // }
  //
  // bool checkFileExist(String path, {bool create = false}) {
  //   return false;
  // }

  writeContentTo(File? file, String content) async {
    file?.writeAsStringSync(content + "\n", mode: FileMode.append);
  }

  List<LogFileInfo> getAllSubFile(String path) {
    Directory directory = Directory(path);
    if (directory.existsSync()) {
      List<LogFileInfo> logList = directory.listSync().map((e) => _buildLogFile(e)).toList();
      logList.sort((a, b) {
        return b.lastModifyDate.compareTo(a.lastModifyDate);
      });
      return logList;
    }
    return [];
  }

  LogFileInfo _buildLogFile(FileSystemEntity systemEntity) {

    File sysFie = File(systemEntity.path);
    String name = "";
    List<String> dirList = systemEntity.path.split(Platform.pathSeparator);
    if (dirList.isNotEmpty) {
      name = dirList.last;
    }

    int size = sysFie.lengthSync();
    DateTime lastModifiedDate = sysFie.lastModifiedSync();
    String dateStr = lastModifiedDate.toString();
    dateStr = dateStr.split('.')[0];
    return LogFileInfo(systemEntity.uri, name, size, _getFileSizeDes(size.toDouble()), dateStr);
  }

  String _getFileSizeDes(double size) {
    List<String> unitList = [
      "B", "K", "M", "G",
    ];

    int unitIndex = 0;
    while (size > 1024) {
      unitIndex++;
      size = size / 1024;
      if (unitIndex >= unitList.length) {
        break;
      }
    }

    String sizeDes = size.toStringAsFixed(2);
    return sizeDes + unitList[unitIndex];
  }
}
