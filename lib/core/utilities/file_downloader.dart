import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloader {
  Future<(bool, String)> downloadFile(
    String url,
    String fileName,
    void Function(int, int)? onReceiveProgress,
  ) async {
    try {
      bool permissionGranted = await _requestPermission();
      if (!permissionGranted) {
        return (false, "Permission denied");
      }

      Directory? directory = await _getDownloadPath();
      if (directory == null || !await directory.exists()) {
        return (false, "Directory does not exist");
      }

      Dio dio = Dio();
      File saveFile = File("${directory.path}/$fileName.pdf");

      if (saveFile.existsSync()) {
        saveFile.deleteSync();
      }

      var response = await dio.download(url, saveFile.path,
          onReceiveProgress: onReceiveProgress);

      if (response.statusCode == 200) {
        return (true, saveFile.path);
      } else {
        return (false, "Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      return (false, "Error: ${e.toString()}");
    }
  }

  Future<Directory?> _getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download/file_downloader');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      }
    } catch (err) {
      debugPrint("Cannot get download folder path: $err");
    }
    debugPrint(directory?.path);
    return directory;
  }

  Future<bool> _requestPermission() async {
    PermissionStatus status = await Permission.storage.status;
    print(status);

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (status.isDenied) {
        if (androidInfo.version.sdkInt < 33) {
          status = await Permission.storage.request();
        } else {
          status = await Permission.phone.request();
        }
      }
    } else if (Platform.isIOS) {
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
    }

    if (status.isGranted) {
      return true;
    } else {
      debugPrint('Permission denied');
      return false;
    }
  }
}
