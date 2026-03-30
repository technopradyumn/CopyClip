import 'package:hive/hive.dart';
import 'calendar_event_model.dart';

class CalendarEventAdapter extends TypeAdapter<CalendarEvent> {
  @override
  final int typeId = 21;

  @override
  CalendarEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarEvent(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      isAllDay: fields[5] as bool,
      location: fields[6] as String?,
      url: fields[7] as String?,
      colorCode: fields[8] as String?,
      repeatInterval: fields[9] as String?,
      reminderMinutesBefore: fields[10] as int? ?? 0,
      isDeleted: fields[11] as bool? ?? false,
      createdAt: fields[12] as DateTime?,
      designPatternId: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarEvent obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.isAllDay)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.url)
      ..writeByte(8)
      ..write(obj.colorCode)
      ..writeByte(9)
      ..write(obj.repeatInterval)
      ..writeByte(10)
      ..write(obj.reminderMinutesBefore)
      ..writeByte(11)
      ..write(obj.isDeleted)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.designPatternId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
