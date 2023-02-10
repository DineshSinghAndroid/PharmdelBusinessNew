
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../../WidgetController/Toast/ToastCustom.dart';
import '../PrintLog/PrintLog.dart';

class DownloadFileCustom {

  static Future<bool?> saveFile(String fileName) async {
    var file = File('');

    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        const downloadsFolderPath = '/storage/emulated/0/Download/';
        Directory dir = Directory(downloadsFolderPath);
        file = File('${dir.path}/$fileName');
        return true;
      }else{
        ToastCustom.showToast( msg: kStoragePermissionToast);
      }
    } else if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      file = File('${dir.path}/$fileName');
      return true;
    }
    return false;
  }

  static Future<bool?> saveFileFromUrl({required String url,required BuildContext context}) async {
    Dio dio = Dio();
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        var tempDir = await getTemporaryDirectory();
        String fullPath = "${tempDir.path}/boo2.pdf'";
        PrintLog.printLog('full path $fullPath');

        downloadFile(dio,url,fullPath).then((value) {
        });

        return true;
      }else{
        ToastCustom.showToast( msg: kStoragePermissionToast);
      }
    } else if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      dio.download(url, dir.path);
      return true;
    }
    return false;
  }

  static   Future downloadFile(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      PrintLog.printLog(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      PrintLog.printLog(e);
    }
  }
  static Future<void> showDownloadProgress(received, total) async {
    if (total != -1) {
      PrintLog.printLog((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}