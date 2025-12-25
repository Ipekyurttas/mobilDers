// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dizi_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiziAdapter extends TypeAdapter<Dizi> {
  @override
  final int typeId = 1;

  @override
  Dizi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dizi(
      ad: fields[0] as String,
      yonetmen: fields[1] as String,
      tur: fields[2] as String,
      puan: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Dizi obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.ad)
      ..writeByte(1)
      ..write(obj.yonetmen)
      ..writeByte(2)
      ..write(obj.tur)
      ..writeByte(3)
      ..write(obj.puan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiziAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
