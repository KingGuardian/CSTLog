import 'dart:io';

import 'package:cstlog/src/constant/constant.dart';
import 'package:cstlog/src/core/config.dart';
import 'package:cstlog/src/model/log_file_info.dart';
import 'package:cstlog/src/model/log_info.dart';
import 'package:cstlog/src/printer/file/file_config.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  static final FileUtil instantce = FileUtil._();

  FileUtil._();

  void writeContentTo(File? file, String content,
      {FileMode mode = FileMode.append}) async {
    if (content.isEmpty) {
      return;
    }
    try {
      file?.writeAsStringSync(content + '\n', mode: mode);
    } catch (e) {
      print(e.toString());
    }
  }

  List<LogFileInfo> getAllSubFile(String path) {
    Directory directory = Directory(path);
    if (directory.existsSync()) {
      List<LogFileInfo> logList =
          directory.listSync().map((e) => _buildLogFile(e)).toList();
      logList.sort((a, b) {
        return b.lastModifyDate.compareTo(a.lastModifyDate);
      });
      return logList;
    }
    return [];
  }

  List<RecordInfo> getAllRecordFile(String path) {
    Directory directory = Directory(path);
    if (directory.existsSync()) {
      List<RecordInfo> recordList =
          directory.listSync().map((e) => _buildRecordInfo(e)).toList();
      recordList.sort((a, b) {
        return b.date.compareTo(a.date);
      });
      return recordList;
    }
    return [];
  }

  LogFileInfo _buildLogFile(FileSystemEntity systemEntity) {
    File sysFie = File(systemEntity.path);
    String name = '';
    List<String> dirList = systemEntity.path.split(Platform.pathSeparator);
    if (dirList.isNotEmpty) {
      name = dirList.last;
      List<String> nameList = name.split('.');
      if (nameList.isNotEmpty) {
        name = nameList.first;
      }
    }

    int size = sysFie.lengthSync();
    DateTime lastModifiedDate = sysFie.lastModifiedSync();
    String dateStr = lastModifiedDate.toString();
    dateStr = dateStr.split('.')[0];
    return LogFileInfo(systemEntity.uri, name, size,
        _getFileSizeDes(size.toDouble()), dateStr);
  }

  RecordInfo _buildRecordInfo(FileSystemEntity systemEntity) {
    final sysFile = File(systemEntity.path);
    String name = '';
    List<String> dirList = systemEntity.path.split(Platform.pathSeparator);
    if (dirList.isNotEmpty) {
      name = dirList.last;
      List<String> nameList = name.split('.');
      if (nameList.isNotEmpty) {
        name = nameList.first;
        name = Uri.decodeFull(name);
      }
    }

    final fileContent = sysFile.readAsStringSync();
    RecordInfo recordInfo = RecordInfo.frromJson(fileContent);
    recordInfo.uri = systemEntity.uri;
    recordInfo.fileName = name;
    return recordInfo;
  }

  String _getFileSizeDes(double size) {
    List<String> unitList = [
      'B',
      'K',
      'M',
      'G',
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

  Future<Directory?> getDeviceStoragePath(LogStorageType storageType) async {
    Directory? storageDirectory = await getExternalStorageDirectory();
    switch (storageType) {
      case LogStorageType.externalDoucument:
        String path = storageDirectory?.path ?? '';
        if (path.isNotEmpty) {
          final pathList = path.split('Android');
          path = pathList[0] +
              'Documents' +
              Platform.pathSeparator +
              additelFolderName;
          storageDirectory = Directory(path);
        } else {
          storageDirectory = await getApplicationDocumentsDirectory();
        }
        break;
      case LogStorageType.applicationSupport:
        storageDirectory = await getApplicationSupportDirectory();
        break;
      default:
        break;
    }
    return storageDirectory;
  }

  ///获取指定目录下占用空间大小，单位K
  Future<double> calculateSize(String path) async {
    double size = 0;
    Directory directory = Directory(path);
    if (directory.existsSync()) {
      List<FileSystemEntity> fileList = directory.listSync();
      for (final entity in fileList) {
        File file = File(entity.path);
        //size单位是K
        size += file.lengthSync() / 1024;
      }
    }
    return size;
  }
}
