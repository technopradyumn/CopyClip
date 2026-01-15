import 'package:hive/hive.dart';
import 'expense_model.dart';

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 3;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      currency: fields[3] as String,
      date: fields[4] as DateTime,
      category: fields[5] as String,
      isIncome: fields[6] as bool,
      sortIndex: fields[7] as int? ?? 0,
      isDeleted: fields[10] as bool? ?? false,
      deletedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(12) // Updated total count (original 8 + 2 new + potential future fields)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.title)
      ..writeByte(2)..write(obj.amount)
      ..writeByte(3)..write(obj.currency)
      ..writeByte(4)..write(obj.date)
      ..writeByte(5)..write(obj.category)
      ..writeByte(6)..write(obj.isIncome)
      ..writeByte(7)..write(obj.sortIndex)
      ..writeByte(10)..write(obj.isDeleted)
      ..writeByte(11)..write(obj.deletedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExpenseAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}