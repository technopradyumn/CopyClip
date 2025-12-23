import 'package:hive/hive.dart';
import 'todo_model.dart';

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 2;

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      id: fields[0] as String,
      task: fields[1] as String,
      category: fields[2] as String,
      isDone: fields[3] as bool,
      dueDate: fields[4] as DateTime?,
      hasReminder: fields[5] as bool,
      // FIX: Read the new fields
      sortIndex: fields[6] as int? ?? 0,
      isDeleted: fields[10] as bool? ?? false,
      deletedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(9) // Updated count to 9 (Original 6 + 3 new fields)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.task)
      ..writeByte(2)..write(obj.category)
      ..writeByte(3)..write(obj.isDone)
      ..writeByte(4)..write(obj.dueDate)
      ..writeByte(5)..write(obj.hasReminder)
      ..writeByte(6)..write(obj.sortIndex)
    // FIX: Explicitly write the deletion fields
      ..writeByte(10)..write(obj.isDeleted)
      ..writeByte(11)..write(obj.deletedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TodoAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}