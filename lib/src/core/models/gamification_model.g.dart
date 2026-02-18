// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GamificationModelAdapter extends TypeAdapter<GamificationModel> {
  @override
  final int typeId = 20;

  @override
  GamificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GamificationModel(
      xp: fields[0] as int,
      level: fields[1] as int,
      streak: fields[2] as int,
      lastActiveDate: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GamificationModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.xp)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.streak)
      ..writeByte(3)
      ..write(obj.lastActiveDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GamificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
