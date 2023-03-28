import 'dart:io';

import 'package:cstlog/cstlog.dart';
import 'package:cstlog_example/GeneralDialog.dart';
import 'package:cstlog_example/log_content.dart';
import 'package:cstlog_example/record_content.dart';
import 'package:cstlog_example/record_list.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'log_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "Home": (BuildContext context) => const HomePage(),
        "LogList": (BuildContext context) => const LogListPage(),
        "RecordList": (BuildContext context) => const RecordListPage(),
        "LogContent": (BuildContext context) => const LogContentPage(),
        "RecordContent": (BuildContext context) => const RecordContentPage(),
      },
      initialRoute: "Home",
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleController;
  TextEditingController? contentController;
  TextEditingController? operatorController;

  late Logger logInstance;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: "维修记录标题");
    contentController = TextEditingController(text: "维修记录内容");
    operatorController = TextEditingController(text: "维修记录操作人");

    LogConfig config = LogConfigBuilder()
        .withLogStorageType(LogStorageType.externalStorage)
        .withFileExtensionName('ext')
        .build();
    logInstance = Logger.init(config: config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: TextField(
            controller: titleController,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: TextField(
            controller: contentController,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: TextField(
            controller: operatorController,
          ),
        ),
        ElevatedButton(
          child: const Text("添加维修记录"),
          onPressed: () {
            String title = titleController?.text ?? "";
            String content = contentController?.text ?? "";
            String operator = operatorController?.text ?? "";
            DateTime dateTime = DateTime.now();
            String year = dateTime.year.toString();
            String month = dateTime.month.toString().padLeft(2, '0');
            String day = dateTime.day.toString().padLeft(2, '0');
            if (title.isNotEmpty && content.isNotEmpty) {
              //添加日志
              logInstance.record(
                  title, content, operator, year + '_' + month + '_' + day);
            }
          },
        ),
        ElevatedButton(
          child: const Text("查看维修记录"),
          onPressed: () {
            Navigator.of(context).pushNamed("RecordList");
          },
        ),
        ElevatedButton(
          child: const Text("打印当前堆栈信息"),
          onPressed: () {
            _printCurStraceInfo();
          },
        ),
        ElevatedButton(
          child: const Text("查看开发日志"),
          onPressed: () {
            Navigator.of(context).pushNamed("LogList");
          },
        ),
        ElevatedButton(
          child: const Text("U盘路径"),
          onPressed: () {
            _checkExternalPath();
          },
        ),
        ElevatedButton(
          child: const Text("导出维修记录文件"),
          onPressed: () {
            _showExportDialog(context);
          },
        ),
        ElevatedButton(
          child: const Text("导出日志文件"),
          onPressed: () {
            _exportFiles(context, true);
          },
        ),
        ElevatedButton(
          child: const Text("申请权限"),
          onPressed: () {
            _checkPermission();
          },
        ),
      ],
    );
  }

  Future<void> _checkPermission() async {
    final storagePermission = await _requestStoragePersmission();
    if (storagePermission) {
      _requestManageStoratePermission();
    }
  }

  _checkExternalPath() async {
    String path = "";
    List<Directory>? dirList = await getExternalStorageDirectories();
    if (dirList != null && dirList.isNotEmpty) {
      for (Directory dir in dirList) {
        path = path + dir.path + "\n";
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(path)));
  }

  _showExportDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return GeneralDialog(
            title: "提示",
            content: "确定导出日志到U盘？",
            callback: () {
              _exportFiles(context, false);
            },
          );
        });
  }

  _exportFiles(BuildContext context, bool isLog) async {
    String errorMessage = '';
    List<Directory>? dirList = await getExternalStorageDirectories();
    if (dirList == null || dirList.isEmpty || dirList.length == 1) {
      errorMessage = "未检测到U盘";
    } else {
      String path = dirList.last.path;
      final pathList = path.split('Android');
      path = pathList[0] + 'Documents' + Platform.pathSeparator + 'export';

      if (isLog) {
        final logList = await logInstance.loadLogs();
        errorMessage = await logInstance.exportLogs(path, logList);
      } else {
        final recordList = await logInstance.loadRecords();
        errorMessage = await logInstance.exportRecords(path, recordList);
      }
      if (errorMessage.isEmpty) {
        errorMessage = "导出成功";
      }
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  _printCurStraceInfo() {
    logInstance.log(Level.error, "打印堆栈信息", "错误原因：人为打印", StackTrace.current);
  }

  Future<bool> _requestStoragePersmission() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      }
    }
    return false;
  }

  _requestManageStoratePermission() async {
    var status = await Permission.manageExternalStorage.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      }
    }
    return false;
  }
}
