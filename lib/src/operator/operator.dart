import 'package:cstlog/cstlog.dart';

abstract class Operator {
  Future<String> exportDevelopLogTo(String path, List<LogFileInfo> logList);

  Future<String> exportRecordTo(String path, List<RecordInfo> recordList);
}
