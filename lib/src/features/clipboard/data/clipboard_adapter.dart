import 'package:hive/hive.dart';
import 'clipboard_model.dart';

class ClipboardItemAdapter extends TypeAdapter<ClipboardItem> {
  @override
  final int typeId = 5;

  @override
  ClipboardItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClipboardItem(
      id: fields[0] as String,
      content: fields[1] as String,
      createdAt: fields[2] as DateTime,
      type: fields[3] as String,
      sortIndex: fields[4] as int? ?? 0,
      colorValue: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ClipboardItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.content)
      ..writeByte(2)..write(obj.createdAt)
      ..writeByte(3)..write(obj.type)
      ..writeByte(4)..write(obj.sortIndex)
      ..writeByte(5)..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ClipboardItemAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}