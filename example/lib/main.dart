import 'dart:io';

import 'package:cstlog/cstlog.dart';
import 'package:cstlog_example/log_content.dart';
import 'package:cstlog_example/record_list.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'log_list.dart';

Logger logInstance = Logger.init();

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "Home": (BuildContext context) => const HomePage(),
        "LogList": (BuildContext context) => const LogListPage(),
        "RecordList": (BuildContext context) => const RecordListPage(),
        "LogContent": (BuildContext context) => const LogContentPage(),
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

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: "维修记录标题");
    contentController = TextEditingController(text: "维修记录内容");
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
        ElevatedButton(
          child: const Text("添加维修记录"),
          onPressed: () {
            String title = titleController?.text ?? "";
            String content = contentController?.text ?? "";
            if (title.isNotEmpty && content.isNotEmpty) {
              //添加日志
              logInstance.record(title, content);
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
          child: const Text("复制文件"),
          onPressed: () {
            _copyFiles();
          },
        ),
        ElevatedButton(
          child: const Text("申请权限"),
          onPressed: () {
            _requestStoragePersmission();
          },
        ),
      ],
    );
  }

  _checkExternalPath() async {
    List<Directory>? dirList = await getExternalStorageDirectories();
    Directory documentDir = await getApplicationDocumentsDirectory();
    Directory? extDir = await getExternalStorageDirectory();
    if (dirList != null && !dirList.isNotEmpty) {
      for (Directory dir in dirList) {
        print(dir.path);
      }
    }
  }

  _copyFiles() async {
    String path = '/storage/emulated/0/TestFolder';
    logInstance.copyToFlashMemoryDiskFromPath(path);
  }

  _printCurStraceInfo() {
    logInstance.log(Level.error, "打印堆栈信息", "错误原因：人为打印", StackTrace.current);
  }

  _requestStoragePersmission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        print("success get permission");
      }
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }
  }
}
