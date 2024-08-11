import 'package:hive/hive.dart';

part 'file_download.g.dart';

@HiveType(typeId: 0)
class FileDownload extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fileName;

  @HiveField(2)
  String? pathName;

  FileDownload({this.id, this.fileName, this.pathName});
}
