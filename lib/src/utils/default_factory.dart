import 'package:cstlog/src/core/config.dart';
import 'package:cstlog/src/loader/file/file_loader.dart';
import 'package:cstlog/src/loader/file/file_loader_config.dart';
import 'package:cstlog/src/printer/file/file_config.dart';
import 'package:cstlog/src/printer/file/file_printer.dart';

class DefaultFactory {
  static LogConfig buildDefaultLogConfig() {
    return LogConfigBuilder().build();
  }

  static FilePrinter buildDefaultPrinter(LogConfig? logConfig) {
    FilePrinterConfig config = FilePrinterConfigBuilder().build();
    return FilePrinter(config);
  }

  static FileLogLoader buildDefaultLogLoader(LogConfig? logConfig) {
    FileLoaderConfig config = FileLoaderConfigBuilder().build();
    return FileLogLoader(config);
  }
}
