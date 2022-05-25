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
  Future<List<LogFileInfo>> loadLogs() async {
    Directory? logDir = await getLogStoragePath();
    if (logDir == null) {
      return [];
    }
    String logPath = logDir.path + Platform.pathSeparator + _loaderConfig.folderName;
    return FileUtil.instantce.getAllSubFile(logPath);
  }

  Future<Directory?> getLogStoragePath() async {
    Directory? storageDirectory;
    switch (_loaderConfig.storageType) {
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
}
