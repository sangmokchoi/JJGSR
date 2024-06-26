// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Quiz.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizAdapter extends TypeAdapter<Quiz> {
  @override
  final int typeId = 0;

  @override
  Quiz read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quiz(
      id: fields[0] as String,
      generatedTime: fields[1] as DateTime,
      category: fields[2] as String,
      first_category: fields[3] as String?,
      second_category: fields[4] as String?,
      third_category: fields[5] as String?,
      title: fields[6] as String?,
      question: fields[7] as String,
      choices: (fields[8] as List).cast<String>(),
      answer: fields[9] as String,
      like_count: fields[10] as int?,
      dislike_count: fields[11] as int?,
      progress_Time: fields[12] as double?,
      status: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Quiz obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.generatedTime)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.first_category)
      ..writeByte(4)
      ..write(obj.second_category)
      ..writeByte(5)
      ..write(obj.third_category)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.question)
      ..writeByte(8)
      ..write(obj.choices)
      ..writeByte(9)
      ..write(obj.answer)
      ..writeByte(10)
      ..write(obj.like_count)
      ..writeByte(11)
      ..write(obj.dislike_count)
      ..writeByte(12)
      ..write(obj.progress_Time)
      ..writeByte(13)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
