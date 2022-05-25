import 'package:cstlog/src/constant/constant.dart';

class LogConfig {
  final String folderName;
  final LogStorageType logStorageType;

  LogConfig(LogConfigBuilder builder)
      : folderName = builder.folderName,
        logStorageType = builder.storageType;
}

class LogConfigBuilder {
  String folderName = cstFolderName;
  LogStorageType storageType = LogStorageType.applicationDoucument;

  LogConfigBuilder logStorageType(LogStorageType logStorageType) {
    storageType = logStorageType;
    return this;
  }

  LogConfigBuilder logFolderName(String name) {
    folderName = name;
    return this;
  }

  LogConfig build() {
    return LogConfig(this);
  }
}

enum LogStorageType {
  applicationSupport,
  applicationDoucument,
  externalStorage,
}
