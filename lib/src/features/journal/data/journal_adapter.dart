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
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.title)
      ..writeByte(2)..write(obj.content)
      ..writeByte(3)..write(obj.date)
      ..writeByte(4)..write(obj.mood)
      ..writeByte(5)..write(obj.sortIndex)
      ..writeByte(6)..write(obj.tags)
      ..writeByte(7)..write(obj.isFavorite)
      ..writeByte(8)..write(obj.colorValue);
  }
}