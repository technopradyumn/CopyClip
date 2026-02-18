// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SocialPostAdapter extends TypeAdapter<SocialPost> {
  @override
  final int typeId = 8;

  @override
  SocialPost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SocialPost(
      id: fields[0] as String,
      content: fields[1] as String,
      mediaPaths: (fields[2] as List).cast<String>(),
      platformIndex: fields[3] as int,
      isFavorite: fields[4] as bool,
      isDraft: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SocialPost obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.mediaPaths)
      ..writeByte(3)
      ..write(obj.platformIndex)
      ..writeByte(4)
      ..write(obj.isFavorite)
      ..writeByte(5)
      ..write(obj.isDraft)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialPostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
