import 'dart:io';

abstract class FileSplitStrategy {
  bool isNeedCreateNewFile(File? file);
}

class FixedSizeStrategy implements FileSplitStrategy {

  /// 固定大小，单位KB
  final int maxSize;

  FixedSizeStrategy(this.maxSize);

  @override
  bool isNeedCreateNewFile(File? file) {
    if (file == null) {
      return false;
    }
    int size = file.lengthSync();
    return size.toDouble() / 1024 > maxSize;
  }
}
