import 'package:hive/hive.dart';
import 'journal_model.dart';

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 4;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      date: fields[3] as DateTime,
      mood: fields[4] as String,
      sortIndex: fields[5] as int? ?? 0,
      tags: (fields[6] as List?)?.cast<String>() ?? [],
      isFavorite: fields[7] as bool? ?? false,
      colorValue: fields[8] as int?,
      // FIX: Ensure the deletion fields are retrieved from storage
      isDeleted: fields[10] as bool? ?? false,
      deletedAt: fields[11] as DateTime?,
      designId: fields[12] as String?,
      pageDesignId: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(13) // Total count updated to 13 (11 + 2 new)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.mood)
      ..writeByte(5)
      ..write(obj.sortIndex)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.isFavorite)
      ..writeByte(8)
      ..write(obj.colorValue)
      // FIX: Explicitly write the deletion fields to disk
      ..writeByte(10)
      ..write(obj.isDeleted)
      ..writeByte(11)
      ..write(obj.deletedAt)
      ..writeByte(12)
      ..write(obj.designId)
      ..writeByte(13)
      ..write(obj.pageDesignId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
