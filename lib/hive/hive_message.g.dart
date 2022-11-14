// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalMessageModelAdapter extends TypeAdapter<LocalMessageModel> {
  @override
  final int typeId = 1;

  @override
  LocalMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalMessageModel(
      id: fields[0] as int?,
      provider: fields[1] as String?,
      message: fields[4] as String?,
      sendDateTime: fields[2] as String?,
      senderUid: fields[5] as String,
      receiverUid: fields[6] as String,
      containFiles: fields[7] as bool,
      fileUrl: fields[8] as String?,
      hasBeenRead: fields[3] as bool,
      groupDateTime: fields[9] as String?,
      haveBeenSend: fields[10] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalMessageModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.provider)
      ..writeByte(2)
      ..write(obj.sendDateTime)
      ..writeByte(3)
      ..write(obj.hasBeenRead)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.senderUid)
      ..writeByte(6)
      ..write(obj.receiverUid)
      ..writeByte(7)
      ..write(obj.containFiles)
      ..writeByte(8)
      ..write(obj.fileUrl)
      ..writeByte(9)
      ..write(obj.groupDateTime)
      ..writeByte(10)
      ..write(obj.haveBeenSend);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
