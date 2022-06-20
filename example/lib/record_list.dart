import 'package:cstlog/cstlog.dart';
import 'package:cstlog_example/main.dart';
import 'package:flutter/material.dart';

class RecordListPage extends StatefulWidget {
  const RecordListPage({Key? key}) : super(key: key);

  @override
  State<RecordListPage> createState() => _RecordListPageState();
}

class _RecordListPageState extends State<RecordListPage> {
  List<RecordInfo> logList = [];

  late Logger logInstance;

  @override
  void initState() {
    super.initState();

    LogConfig config = LogConfigBuilder().withLogStorageType(LogStorageType.externalStorage).build();
    logInstance = Logger.init(config: config);

    _loadLogs();
  }

  _loadLogs() async {
    logList = await logInstance.loadRecords();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    logInstance.loadLogs();

    return Scaffold(
      appBar: AppBar(
        title: const Text("维修记录列表"),
        actions: [IconButton(onPressed: () {
          SnackBar snack = const SnackBar(content: Text("添加维修日志"));
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }, icon: const Icon(Icons.add))],
      ),
      body: logList.isEmpty
          ? const Text("暂无维修记录")
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
    RecordInfo entity = logList[index];

    return ListTile(
      leading: const Icon(Icons.insert_drive_file_rounded),
      title: Text(
        entity.fileName ?? entity.title,
        style: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        entity.date,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      onTap: () {
        Navigator.of(context).pushNamed("RecordContent", arguments: entity);
      },
    );
  }
}
