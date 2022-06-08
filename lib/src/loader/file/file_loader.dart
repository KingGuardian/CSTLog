import 'dart:io';

import 'package:cstlog/src/core/config.dart';
import 'package:cstlog/src/loader/file/file_loader_config.dart';
import 'package:cstlog/src/loader/loader.dart';
import 'package:cstlog/src/model/log_file_info.dart';
import 'package:cstlog/src/utils/file_utils.dart';
import 'package:path_provider/path_provider.dart';

class FileLogLoader implements LogLoader {
  final FileLoaderConfig _loaderConfig;

  FileLogLoader(this._loaderConfig);

  @override
  Future<List<LogFileInfo>> loadRecords() async {
    String? recordPath = await _getRecordStoragePath();
    if (recordPath == null) {
      return [];
    }
    return FileUtil.instantce.getAllSubFile(recordPath);
  }

  @override
  Future<List<LogFileInfo>> loadLogs() async {
    String? logPath = await _getLogStoragePath();
    if (logPath == null) {
      return [];
    }
    return FileUtil.instantce.getAllSubFile(logPath);
  }

  Future<String?> _getLogStoragePath() async {
    return _getTargetStoragePath(_loaderConfig.logFolderName);
  }

  Future<String?> _getRecordStoragePath() async {
    return _getTargetStoragePath(_loaderConfig.recordFolderName);
  }

  Future<String?> _getTargetStoragePath(String folderName) async {
    Directory? storageDirectory = await FileUtil.instantce.getDeviceStoragePath(_loaderConfig.storageType);
    String? path = storageDirectory != null
        ? storageDirectory.path + Platform.pathSeparator + folderName
        : null;
    return path;
  }
}
