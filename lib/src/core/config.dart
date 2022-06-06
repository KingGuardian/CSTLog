import 'package:cstlog/src/constant/constant.dart';

class LogConfig {
  final String tag;
  final String logFolderName;
  final String recordFolderName;
  final LogStorageType logStorageType;

  LogConfig(LogConfigBuilder builder)
      : tag = builder.tag,
        logFolderName = builder.logFolderName,
        recordFolderName = builder.recordFolderName,
        logStorageType = builder.storageType;
}

class LogConfigBuilder {
  String tag = 'Additel';
  String logFolderName = additelLogFolderName;
  String recordFolderName = additelRecordFolderName;
  LogStorageType storageType = LogStorageType.externalStorage;

  LogConfigBuilder withTag(String tag) {
    this.tag = tag;
    return this;
  }

  LogConfigBuilder withLogStorageType(LogStorageType logStorageType) {
    storageType = logStorageType;
    return this;
  }

  LogConfigBuilder withLogFolderName(String name) {
    logFolderName = name;
    return this;
  }

  LogConfigBuilder withRecordFolderName(String name) {
    recordFolderName = name;
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
