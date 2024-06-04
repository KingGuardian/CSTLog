import 'dart:io';

import 'package:cstlog/cstlog.dart';
import 'package:cstlog/src/constant/constant.dart';
import 'package:cstlog/src/operator/operator.dart';

class FileOperator implements Operator {
  final String fileExtensionName;

  FileOperator(this.fileExtensionName);

  @override
  Future<String> exportDevelopLogTo(
      String path, List<LogFileInfo> logList) async {
    String errorMessage = '';
    final newLogPath = path + Platform.pathSeparator + additelLogFolderName;
    try {
      await _createFolderIfNotExist(newLogPath);
    } catch (error) {
      errorMessage = error.toString();
      return errorMessage;
    }
    try {
      for (LogFileInfo logFileInfo in logList) {
        await _copyWithRetry(
          newLogPath: newLogPath,
          fileName: logFileInfo.fileName,
          oldfileUri: logFileInfo.uri,
        );
        // 为了避免文件复制失败，延迟一段时间
        await Future.delayed(Duration(milliseconds: 100));
      }
    } catch (error) {
      errorMessage = error.toString();
    }
    return errorMessage;
  }

  @override
  Future<String> exportRecordTo(
      String path, List<RecordInfo> recordList) async {
    String errorMessage = '';
    final newRecordPath =
        path + Platform.pathSeparator + additelRecordFolderName;
    try {
      await _createFolderIfNotExist(newRecordPath);
    } catch (error) {
      errorMessage = error.toString();
      return errorMessage;
    }

    try {
      for (RecordInfo recordInfo in recordList) {
        final uri = recordInfo.uri;
        if (uri != null) {
          await _copyWithRetry(
            newLogPath: newRecordPath,
            fileName: recordInfo.fileName ?? recordInfo.title,
            oldfileUri: uri,
          );
          // 为了避免文件复制失败，延迟一段时间
          await Future.delayed(Duration(milliseconds: 100));

          // final file = File.fromUri(uri);
          // String fileName = recordInfo.fileName ?? recordInfo.title;
          // await file.copy(newRecordPath +
          //     Platform.pathSeparator +
          //     fileName +
          //     '.' +
          //     fileExtensionName);
        }
      }
    } catch (error) {
      errorMessage = error.toString();
    }
    return errorMessage;
  }

  Future<void> _copyWithRetry({
    required String newLogPath,
    required String fileName,
    required Uri oldfileUri,
  }) async {
    final targetFilePath = newLogPath +
        Platform.pathSeparator +
        fileName +
        '.' +
        fileExtensionName;
    final file = File.fromUri(oldfileUri);
    int retryTimes = 5;
    while (retryTimes > 0) {
      try {
        final targetFile = File(targetFilePath);
        if (targetFile.existsSync()) {
          targetFile.deleteSync();
        }
        final copiedFile = file.copySync(targetFilePath);
        // 不确定是否真的复制成功，延迟一段时间再检查
        Future.delayed(Duration(milliseconds: 100));
        // 检查是否真的复制成功
        if (copiedFile.existsSync()) {
          final targetFileSize = copiedFile.lengthSync();
          final sourceFileSize = file.lengthSync();
          if (targetFileSize == sourceFileSize) {
            break;
          } else {
            retryTimes--;
          }
        } else {
          retryTimes--;
        }
      } catch (error) {
        retryTimes--;
      }
    }
  }

  _createFolderIfNotExist(String path) async {
    Directory director = Directory(path);
    if (!director.existsSync()) {
      await director.create(recursive: true);
    }
  }
}
