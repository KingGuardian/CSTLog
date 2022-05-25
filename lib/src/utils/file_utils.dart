import 'dart:io';

class FileUtil {

  static final FileUtil instantce = FileUtil._();

  FileUtil._();

  // bool checkFolderExist(String path, {bool create = false}) {
  //   return false;
  // }
  //
  // bool checkFileExist(String path, {bool create = false}) {
  //   return false;
  // }

  void writeContentTo(File? file, String content) async {
    try {
      file?.writeAsStringSync(content);
    } catch (_) {}
  }

  List<FileSystemEntity> getAllSubFile(String path) {
    Directory directory = Directory(path);
    if (directory.existsSync()) {
      return directory.listSync();
    }
    return [];
  }
}
