import 'package:cstlog/src/constant/constant.dart';
import 'package:cstlog/src/core/config.dart';
import 'package:cstlog/src/printer/file/name_strategy.dart';
import 'package:cstlog/src/printer/file/split_strategy.dart';

class FilePrinterConfig {
  final String logFolderName;
  final String recordFolderName;
  final FileNameStrategy fileNameStrategy;
  final FileSplitStrategy fileSplitStrategy;
  final LogStorageType storageType;

  FilePrinterConfig(FilePrinterConfigBuilder builder)
      : logFolderName = builder.logFolderName,
        recordFolderName = builder.recordFolderName,
        fileNameStrategy = builder.fileNameStrategy,
        fileSplitStrategy = builder.fileSplitStrategy,
        storageType = builder.storageType;
}

class FilePrinterConfigBuilder {
  String logFolderName = additelLogFolderName;
  String recordFolderName = additelRecordFolderName;
  FileNameStrategy fileNameStrategy = DefaultFileNameStrategy();
  FileSplitStrategy fileSplitStrategy = FixedSizeStrategy(maxFileSize);
  LogStorageType storageType = LogStorageType.externalStorage;

  FilePrinterConfigBuilder withLogFolderName(String name) {
    logFolderName = name;
    return this;
  }

  FilePrinterConfigBuilder withRecordFolderName(String name) {
    recordFolderName = name;
    return this;
  }

  FilePrinterConfigBuilder nameStrategy(FileNameStrategy nameStrategy) {
    fileNameStrategy = nameStrategy;
    return this;
  }

  FilePrinterConfigBuilder splitStrategy(FileSplitStrategy spliteStrategy) {
    fileSplitStrategy = spliteStrategy;
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
