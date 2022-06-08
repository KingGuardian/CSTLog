import 'package:cstlog/cstlog.dart';

class RecordInfo {
  final String title;
  final String content;
  final String operatorName;
  final String date;
  Uri? uri;
  String? fileName;

  RecordInfo(this.title, this.content, this.operatorName, this.date);

  factory RecordInfo.initWithFileContent(String fileContent) {
    final contentList = fileContent.split('.\n');
    String title = contentList.isNotEmpty ? contentList[0] : '';
    String operatorName = contentList.length > 1 ? contentList[1] : '';
    String date = contentList.length > 2 ? contentList[2] : '';
    StringBuffer content = StringBuffer('');
    if (contentList.length > 3) {
      final subList = contentList.sublist(3);
      for (var element in subList) {
        content.write(element);
      }
    }
    return RecordInfo(title, content.toString(), operatorName, date);
  }

  String getWriteContent() {
    String writeContent = title;
    writeContent = writeContent + '.\n' + operatorName;
    writeContent = writeContent + '.\n' + date;
    writeContent = writeContent + '.\n' + content;
    return writeContent;
  }
}
