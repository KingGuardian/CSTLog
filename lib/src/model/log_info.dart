import 'dart:convert';

class RecordInfo {
  final String title;
  final String content;
  final String operatorName;
  final String date;
  Uri? uri;
  String? fileName;

  RecordInfo(this.title, this.content, this.operatorName, this.date);

  factory RecordInfo.frromJson(String jsonContent) {
    final Map<String, dynamic> data = json.decode(jsonContent);
    String title = data.containsKey('title') ? data['title'] : '';
    String operatorName = data.containsKey('operatorName') ? data['operatorName'] : '';;
    String content = data.containsKey('content') ? data['content'] : '';;
    String date = data.containsKey('date') ? data['date'] : '';;
    return RecordInfo(title, content, operatorName, date);
  }

  String getWriteContent() {
    return _toJson();
  }

  String _toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    data['operatorName'] = operatorName;
    data['date'] = date;
    return json.encode(data);
  }
}
