// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_download.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileDownloadAdapter extends TypeAdapter<FileDownload> {
  @override
  final int typeId = 0;

  @override
  FileDownload read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileDownload(
      id: fields[0] as int?,
      fileName: fields[1] as String?,
      pathName: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FileDownload obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.pathName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileDownloadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
