// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingModelAdapter extends TypeAdapter<SettingModel> {
  @override
  final int typeId = 1;

  @override
  SettingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingModel(
      isdark: fields[0] as bool,
      isvibration: fields[1] as bool,
      isshowdate: fields[2] as bool,
      issund: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isdark)
      ..writeByte(1)
      ..write(obj.isvibration)
      ..writeByte(2)
      ..write(obj.isshowdate)
      ..writeByte(3)
      ..write(obj.issund);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
