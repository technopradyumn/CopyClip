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
      // ADD THESE TWO LINES:
      isDeleted: fields[10] as bool? ?? false,
      deletedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ClipboardItem obj) {
    writer
      ..writeByte(8) // Increased count from 6 to 8
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.content)
      ..writeByte(2)..write(obj.createdAt)
      ..writeByte(3)..write(obj.type)
      ..writeByte(4)..write(obj.sortIndex)
      ..writeByte(5)..write(obj.colorValue)
    // ADD THESE TWO LINES:
      ..writeByte(10)..write(obj.isDeleted)
      ..writeByte(11)..write(obj.deletedAt);
  }
}