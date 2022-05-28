import 'package:cstlog/src/model/log_event.dart';
import 'package:cstlog/src/model/log_info.dart';

abstract class Printer {
  //维修日志相关
  record(RecordInfo logInfo);

  //记录log
  log(LogEvent logEvent);
}
