import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:cstlog/cstlog.dart';

import 'log_list.dart';

CLog logInstance = CLog.init();

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

    titleController = TextEditingController(text: "日志标题");
    contentController = TextEditingController(text: "日志内容");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body:buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: TextField(controller: titleController,),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: TextField(controller: contentController,),
        ),
        ElevatedButton(onPressed: () {
          String title = titleController?.text ?? "";
          String content = contentController?.text ?? "";
          if (title.isNotEmpty && content.isNotEmpty) {
            //添加日志
            logInstance.logToFile(title, content);
          }
        }, child: const Text("添加日志")),
        ElevatedButton(onPressed: () {
          Navigator.of(context).pushNamed("LogList");
        }, child: const Text("查看日志")),
      ],
    );
  }
}
