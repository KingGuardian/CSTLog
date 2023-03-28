import 'package:cstlog/src/core/config.dart';
import 'package:cstlog/src/loader/file/file_loader.dart';
import 'package:cstlog/src/loader/file/file_loader_config.dart';
import 'package:cstlog/src/printer/file/file_config.dart';
import 'package:cstlog/src/printer/file/file_printer.dart';
import 'package:cstlog/src/printer/file/name_strategy.dart';

class DefaultFactory {
  static LogConfig buildDefaultLogConfig() {
    return LogConfigBuilder().build();
  }

  static FilePrinter buildDefaultPrinter(LogConfig? logConfig) {
    logConfig ??= DefaultFactory.buildDefaultLogConfig();
    FilePrinterConfig config = FilePrinterConfigBuilder()
        .withLogFolderName(logConfig.logFolderName)
        .withRecordFolderName(logConfig.recordFolderName)
        .logStorageType(logConfig.logStorageType)
        .withNameStrategy(DefaultFileNameStrategy(
          logConfig.fileExtensionName,
        ))
        .build();

    return FilePrinter(config);
  }

  static FileLogLoader buildDefaultLogLoader(LogConfig? logConfig) {
    logConfig ??= DefaultFactory.buildDefaultLogConfig();
    FileLoaderConfig config = FileLoaderConfigBuilder()
        .withLogFolderName(logConfig.logFolderName)
        .withRecordFolderName(logConfig.recordFolderName)
        .logStorageType(logConfig.logStorageType)
        .build();
    return FileLogLoader(config);
  }
}
