import 'package:cstlog/src/model/log_event.dart';
import 'package:cstlog/src/model/log_info.dart';

abstract class FileNameStrategy {
  String generateLogFileName(LogEvent logInfo);

  String generateRecordFileName(RecordInfo logInfo);
}

class DefaultFileNameStrategy implements FileNameStrategy {
  final String fileExtensionName;

  DefaultFileNameStrategy(this.fileExtensionName);

  @override
  String generateLogFileName(LogEvent logInfo) {
    // 日志文件的命名规则
    return _getLevelDescription(logInfo) +
        '-' +
        _getDateTime() +
        _getFileTail();
  }

  @override
  String generateRecordFileName(RecordInfo logInfo) {
    // 维修记录文件名加入时间戳，允许同标题维修记录存在
    String fileName = logInfo.title.isEmpty
        ? '维修记录'
        : logInfo.title +
            '_' +
            DateTime.now().millisecondsSinceEpoch.toString();
    fileName = Uri.encodeFull(fileName);
    return fileName + _getFileTail();
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
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}_${month}_$day';
  }

  String _getFileTail() {
    return '.' + fileExtensionName;
  }
}
