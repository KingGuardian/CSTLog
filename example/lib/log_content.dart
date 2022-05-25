import 'dart:io';

import 'package:cstlog/cstlog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogContentPage extends StatelessWidget {
  const LogContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogFileInfo? logFileInfo =
        ModalRoute.of(context)?.settings.arguments as LogFileInfo?;

    if (logFileInfo == null) {
      return _buildEmptyPage();
    }
    String titleContent = logFileInfo.fileName;
    String content = _loadLogContent(logFileInfo);

    return Scaffold(
      appBar: AppBar(
        title: Text(titleContent),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Text(
          content,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildEmptyPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("日志内容"),
      ),
      body: const Center(
        child: Text("无法获取日志内容"),
      ),
    );
  }

  String _loadLogContent(LogFileInfo logFileInfo) {
    File logFile = File.fromUri(logFileInfo.uri);
    return logFile.readAsStringSync();;
  }
}
