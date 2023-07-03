import 'dart:io';

import 'package:cstlog/src/loader/file/file_loader_config.dart';
import 'package:cstlog/src/loader/loader.dart';
import 'package:cstlog/src/model/log_file_info.dart';
import 'package:cstlog/src/model/log_info.dart';
import 'package:cstlog/src/utils/file_utils.dart';

class FileLogLoader implements LogLoader {
  final FileLoaderConfig _loaderConfig;

  FileLogLoader(this._loaderConfig);

  @override
  Future<List<RecordInfo>> loadRecords() async {
    String? recordPath = await _getRecordStoragePath();
    if (recordPath == null) {
      return [];
    }
    return FileUtil.instantce.getAllRecordFile(recordPath);
  }

  @override
  Future<List<LogFileInfo>> loadLogs() async {
    String? logPath = await _getLogStoragePath();
    if (logPath == null) {
      return [];
    }
    return FileUtil.instantce.getAllSubFile(logPath);
  }

  Future<String?> _getLogStoragePath() {
    return _getTargetStoragePath(_loaderConfig.logFolderName);
  }

  Future<String?> _getRecordStoragePath() {
    return _getTargetStoragePath(_loaderConfig.recordFolderName);
  }

  Future<String?> _getTargetStoragePath(String folderName) async {
    Directory? storageDirectory = await FileUtil.instantce
        .getDeviceStoragePath(_loaderConfig.storageType);
    String? path = storageDirectory != null
        ? storageDirectory.path + Platform.pathSeparator + folderName
        : null;
    return path;
  }
}
