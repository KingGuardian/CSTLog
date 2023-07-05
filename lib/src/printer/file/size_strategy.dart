import 'dart:io';

import 'package:cstlog/src/constant/constant.dart';
import 'package:cstlog/src/printer/file/file_config.dart';
import 'package:cstlog/src/utils/file_utils.dart';

abstract class CacheSizeStrategy {
  //查看缓存空间是否已被占满，区分日志和维修记录
  Future<bool> isNeedClearCache();

  //清理缓存空间，区分日志和维修记录
  Future<void> clearCache();
}

//先进先出策略，当达到cache最大值后，删除至空余容量50M为止
class FifoStrategy implements CacheSizeStrategy {
  //从配置中找到储存路径，读取文件，计算大小
  final FilePrinterConfig _config;

  final bool _isLog;

  FifoStrategy(this._config, this._isLog);

  //记录当前cacheSize
  double _curCacheSize = 0;

  @override
  Future<void> clearCache() async {
    String cachePath = await _getCachePath();
    if (cachePath.isNotEmpty) {
      Directory directory = Directory(cachePath);
      if (directory.existsSync()) {
        //读出文件列表，按时间排序
        List fileList = directory.listSync().map((e) => File(e.path)).toList();
        fileList.sort((a, b) {
          return a.lastModifiedSync().compareTo(b.lastModifiedSync());
        });

        int index = 0;
        while (_curCacheSize > maxCacheSize - 1024 * 1024 &&
            index < fileList.length) {
          File file = fileList[index];
          double fileSize = file.lengthSync() / 1024;
          bool deleteSuccess = true;
          try {
            file.deleteSync();
          } catch (e) {
            deleteSuccess = false;
          }
          if (deleteSuccess) {
            _curCacheSize = _curCacheSize - fileSize;
          }
          index++;
        }
      }
    }
  }

  @override
  Future<bool> isNeedClearCache() async {
    _curCacheSize = await _calculateCacheSize();
    return _curCacheSize > maxCacheSize;
  }

  Future<double> _calculateCacheSize() async {
    double cacheSize = -1;
    String cachePath = await _getCachePath();
    if (cachePath.isNotEmpty) {
      cacheSize = await FileUtil.instantce.calculateSize(cachePath);
    }
    return cacheSize;
  }

  Future<String> _getCachePath() async {
    String path = '';
    Directory? cacheDir =
        await FileUtil.instantce.getDeviceStoragePath(_config.storageType);
    if (cacheDir != null) {
      String folderName =
          _isLog ? _config.logFolderName : _config.recordFolderName;
      path = cacheDir.path + Platform.pathSeparator + folderName;
    }
    return path;
  }
}
