import 'dart:io';

import 'package:cstlog/src/model/log_event.dart';
import 'package:cstlog/src/model/log_info.dart';

abstract class FileNameStrategy {
  String generateLogFileName(LogEvent logInfo);

  String generateRecordFileName(RecordInfo logInfo);
}

class DefaultFileNameStrategy implements FileNameStrategy {
  @override
  String generateLogFileName(LogEvent logInfo) {
    //日志文件的命名规则
    return _getLevelDescription(logInfo) +
        '_' +
        _getDateTime() +
        _getFileTail();
  }

  @override
  String generateRecordFileName(RecordInfo logInfo) {
    String fileName = logInfo.name.isEmpty ? 'AdditelRecord' : logInfo.name;
    return fileName + '_' + _getDateTime() + _getFileTail();
  }

  String _getLevelDescription(LogEvent logInfo) {
    String levelDes = '';
    switch (logInfo.level) {
      case Level.verbose:
        levelDes = 'verbose';
        break;
      case Level.debug:
        levelDes = 'debug';
        break;
      case Level.info:
        levelDes = 'info';
        break;
      case Level.warning:
        levelDes = 'warning';
        break;
      case Level.error:
        levelDes = 'error';
        break;
    }
    return levelDes;
  }

  String _getDateTime() {
    DateTime dateTime = DateTime.now();
    return '${dateTime.year}_${dateTime.month}_${dateTime.day}';
  }

  String _getFileTail() {
    return '.log';
  }
}
