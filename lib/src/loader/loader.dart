import 'dart:io';

abstract class LogLoader {
  Future<List<FileSystemEntity>> loadLogs();
}
