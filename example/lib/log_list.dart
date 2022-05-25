import 'package:cstlog/cstlog.dart';
import 'package:cstlog_example/main.dart';
import 'package:flutter/material.dart';

class LogListPage extends StatefulWidget {
  const LogListPage({Key? key}) : super(key: key);

  @override
  State<LogListPage> createState() => _LogListPageState();
}

class _LogListPageState extends State<LogListPage> {
  List<LogFileInfo> logList = [];

  @override
  void initState() {
    super.initState();

    _loadLogs();
  }

  _loadLogs() async {
    logList = await logInstance.loadLogs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    logInstance.loadLogs();

    return Scaffold(
      appBar: AppBar(
        title: const Text("日志列表"),
      ),
      body: logList.isEmpty
          ? const Text("暂无日志")
          : Container(
              color: Colors.white,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _buildItemView(context, index);
                },
                itemCount: logList.length,
              ),
            ),
    );
  }

  Widget _buildItemView(BuildContext context, int index) {
    LogFileInfo entity = logList[index];

    return ListTile(
      leading: const Icon(Icons.insert_drive_file_rounded),
      title: Text(
        entity.fileName,
        style: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        entity.lastModifyDate,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      onTap: () {
        Navigator.of(context).pushNamed("LogContent", arguments: entity);
      },
    );
  }
}
