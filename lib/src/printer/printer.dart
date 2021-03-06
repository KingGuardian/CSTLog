import 'package:cstlog/src/model/log_event.dart';
import 'package:cstlog/src/model/log_info.dart';

abstract class Printer {
  //维修日志相关
  Future<String> record(RecordInfo logInfo);

  //记录log
  Future<String> log(LogEvent logEvent);
}
