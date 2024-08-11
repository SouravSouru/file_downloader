import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_downloader/data/models/hive_model/file_download.dart';
import 'package:hive/hive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloader {
  static const String boxName = 'File_download';

  static Future<bool> _requestPermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status != PermissionStatus.granted) {
      print('Permission denied. Cannot download the file.');
      return false;
    }
    return true;
  }

  static Future<String?> _getDownloadPath() async {
    Directory? directory;

    print(await getExternalStorageDirectories(type: StorageDirectory.downloads));
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getExternalStorageDirectory();
        if (!await directory!.exists()) {
          await directory.create(recursive: true);
        }
      }
    } catch (err) {
      print("Cannot get download folder path: $err");
    }
    print(directory?.path);
    return directory?.path;
  }

  static Future<(bool, String)> downloadFile({
    required String fileName,
    required String url,
    required Function okCallback,
  }) async {
    final dio = Dio();
    bool isSuccess = false;
    String savePath = '';

    bool permission = await _requestPermission();
    bool isFileAlreadyExist = fileAlreadyExist(fileName: fileName);

    if (permission && !isFileAlreadyExist) {
      String? directory = await _getDownloadPath();
      savePath = '${directory ?? ""}/$fileName.pdf';

      try {
        var response = await dio.download(
          url,
          savePath,
          onReceiveProgress: (count, total) {
            if (total != -1) {
              print('${(count / total * 100).toStringAsFixed(0)}%');
            }
            okCallback(count, total);
          },
          deleteOnError: true,
        );

        if (response.statusCode == 200) {
          isSuccess = true;
          // _storeTheFile(fileName: fileName, pathName: savePath);
        } else {
          isSuccess = false;
        }
      } on Exception catch (e) {
        print("Download failed: $e");
        isSuccess = false;
      }
    } else {
      print(isFileAlreadyExist
          ? "File already exists: $fileName"
          : "Permission denied.");
    }

    return (isSuccess, savePath);
  }

  static void _storeTheFile(
      {required String pathName, required String fileName}) async {
    final box = Hive.box<FileDownload>(boxName);
    final pdfDownload =
        FileDownload(pathName: pathName, fileName: fileName, id: 0);
    await box.add(pdfDownload);
    print("File stored in Hive: $fileName");
  }

  static bool fileAlreadyExist({required String fileName}) {
    final box = Hive.box<FileDownload>(boxName);
    return box.values.any((element) => element.fileName == fileName);
  }
}
