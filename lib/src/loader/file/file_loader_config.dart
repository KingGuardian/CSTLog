import 'package:cstlog/src/constant/constant.dart';
import 'package:cstlog/src/core/config.dart';

class FileLoaderConfig {
  final String logFolderName;
  final String recordFolderName;
  final LogStorageType storageType;

  FileLoaderConfig(FileLoaderConfigBuilder builder)
      : logFolderName = builder.logFolderName,
        recordFolderName = builder.recordFolderName,
        storageType = builder.storageType;
}

class FileLoaderConfigBuilder {
  String logFolderName = additelLogFolderName;
  String recordFolderName = additelRecordFolderName;
  LogStorageType storageType = LogStorageType.externalDoucument;

  FileLoaderConfigBuilder withLogFolderName(String name) {
    logFolderName = name;
    return this;
  }

  FileLoaderConfigBuilder withRecordFolderName(String name) {
    recordFolderName = name;
    return this;
  }

  FileLoaderConfigBuilder logStorageType(LogStorageType logStorageType) {
    storageType = logStorageType;
    return this;
  }

  FileLoaderConfig build() {
    return FileLoaderConfig(this);
  }
}
