// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodomodelAdapter extends TypeAdapter<Todomodel> {
  @override
  final int typeId = 0;

  @override
  Todomodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todomodel(
      todo: fields[0] as String,
      chek: fields[1] as bool,
      isSave: fields[2] as bool,
      key: fields[3] as int?,
      createdAt: fields[4] as DateTime?,
      dueDate: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Todomodel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.todo)
      ..writeByte(1)
      ..write(obj.chek)
      ..writeByte(2)
      ..write(obj.isSave)
      ..writeByte(3)
      ..write(obj.key)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.dueDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodomodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
