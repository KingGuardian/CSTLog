import 'package:cstlog/src/constant/constant.dart';
import 'package:cstlog/src/core/config.dart';
import 'package:cstlog/src/printer/file/name_strategy.dart';

class FilePrinterConfig {
  final String folderName;
  final FileNameStrategy fileNameStrategy;
  final LogStorageType storageType;

  FilePrinterConfig(FilePrinterConfigBuilder builder)
      : folderName = builder.folderName,
        fileNameStrategy = builder.fileNameStrategy,
        storageType = builder.storageType;
}

class FilePrinterConfigBuilder {
  String folderName = cstFolderName;
  FileNameStrategy fileNameStrategy = DefaultFileNameStrategy();
  LogStorageType storageType = LogStorageType.applicationDoucument;

  FilePrinterConfigBuilder logFolderName(String name) {
    folderName = name;
    return this;
  }

  FilePrinterConfigBuilder nameStrategy(FileNameStrategy nameStrategy) {
    fileNameStrategy = nameStrategy;
    return this;
  }

  FilePrinterConfigBuilder logStorageType(LogStorageType logStorageType) {
    storageType = logStorageType;
    return this;
  }

  FilePrinterConfig build() {
    return FilePrinterConfig(this);
  }
}
