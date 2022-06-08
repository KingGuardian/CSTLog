import 'dart:io';

import 'package:cstlog/cstlog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordContentPage extends StatelessWidget {
  const RecordContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecordInfo? recordFileInfo =
        ModalRoute.of(context)?.settings.arguments as RecordInfo?;

    if (recordFileInfo == null) {
      return _buildEmptyPage();
    }
    String titleContent = recordFileInfo.title;
    String content = recordFileInfo.content;

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
}
