
import 'package:cstlog/src/model/log_file_info.dart';

abstract class LogLoader {
  Future<List<LogFileInfo>> loadLogs();
}
