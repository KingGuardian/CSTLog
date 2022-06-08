
import 'package:cstlog/src/model/log_file_info.dart';
import 'package:cstlog/src/model/log_info.dart';

abstract class LogLoader {

  Future<List<RecordInfo>> loadRecords();

  Future<List<LogFileInfo>> loadLogs();
}
