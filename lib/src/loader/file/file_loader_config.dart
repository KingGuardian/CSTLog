import 'package:cstlog/src/constant/constant.dart';
import 'package:cstlog/src/core/config.dart';

class FileLoaderConfig {
  final String folderName;
  final LogStorageType storageType;

  FileLoaderConfig(FileLoaderConfigBuilder builder)
      : folderName = builder.folderName,
        storageType = builder.storageType;
}

class FileLoaderConfigBuilder {
  String folderName = cstFolderName;
  LogStorageType storageType = LogStorageType.applicationDoucument;

  FileLoaderConfigBuilder logFolderName(String name) {
    folderName = name;
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
