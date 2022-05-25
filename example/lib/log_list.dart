import 'dart:io';

import 'package:cstlog_example/main.dart';
import 'package:flutter/material.dart';

class LogListPage extends StatefulWidget {
  const LogListPage({Key? key}) : super(key: key);

  @override
  State<LogListPage> createState() => _LogListPageState();
}

class _LogListPageState extends State<LogListPage> {
  List<FileSystemEntity> logList = [];

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
    return logList.isEmpty
        ? Container(
            child: const Text("暂无日志"),
          )
        : Container(
            color: Colors.white,
            child: ListView.builder(
              itemBuilder: (context, index) {
                FileSystemEntity entity = logList[index];
                String path = entity.path;
                File file = File(path);
                String uriPath = file.uri.path;

                return SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Text(uriPath),
                );
              },
              itemCount: logList.length,
            ),
          );
  }
}
