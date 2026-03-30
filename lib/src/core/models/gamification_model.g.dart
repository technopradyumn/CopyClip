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
      totalXp: fields[0] as int? ?? 0,
      level: fields[1] as int? ?? 1,
      streak: fields[2] as int? ?? 0,
      bestStreak: fields[5] as int? ?? 0,
      lastActiveDate: fields[3] as DateTime? ?? DateTime.now(),
      dailyFeatureXp: fields[4] != null
          ? (fields[4] as Map).map((k, v) => MapEntry(
                k as String,
                (v as Map).cast<String, int>(),
              ))
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, GamificationModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.totalXp)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.streak)
      ..writeByte(3)
      ..write(obj.lastActiveDate)
      ..writeByte(4)
      ..write(obj.dailyFeatureXp)
      ..writeByte(5)
      ..write(obj.bestStreak);
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
