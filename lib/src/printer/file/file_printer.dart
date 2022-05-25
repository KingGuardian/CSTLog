import 'dart:io';

import 'package:cstlog/src/core/config.dart';
import 'package:cstlog/src/model/log_info.dart';
import 'package:cstlog/src/printer/file/file_config.dart';
import 'package:cstlog/src/printer/printer.dart';
import 'package:cstlog/src/utils/file_utils.dart';
import 'package:path_provider/path_provider.dart';

class FilePrinter implements Printer {
  final FilePrinterConfig _fileConfig;
  Directory? folderDir;

  FilePrinter(this._fileConfig);

  @override
  print(LogInfo logInfo) async {
    File? logFile = await _initLogFile(logInfo);
    FileUtil.instantce.writeContentTo(logFile, logInfo.content);
  }

  Future<File?> _initLogFile(LogInfo logInfo) async {
    if (folderDir == null) {
      Directory? storateDir = await getLogStoragePath();

      if (storateDir == null) {
        //可能平台不支持
        return null;
      }
      if (!storateDir.existsSync()) {
        storateDir.createSync(recursive: true);
      }

      folderDir = Directory(
          storateDir.path + Platform.pathSeparator + _fileConfig.folderName);
    }

    if (folderDir != null && !folderDir!.existsSync()) {
      folderDir?.createSync(recursive: true);
    }

    String fileName = _fileConfig.fileNameStrategy.generateFileName(logInfo);
    String folderPath = folderDir?.path ?? "";
    String filePath = folderPath + Platform.pathSeparator + fileName;

    File logFile = File(filePath);
    if (!logFile.existsSync()) {
      logFile.createSync();
    }
    return logFile;
  }

  Future<Directory?> getLogStoragePath() async {
    Directory? storageDirectory;
    switch (_fileConfig.storageType) {
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
