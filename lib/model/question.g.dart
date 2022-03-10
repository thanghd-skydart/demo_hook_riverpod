// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      json['category'] as String?,
      json['difficulty'] as String?,
      json['question'] as String?,
      (json['incorrect_answers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      json['correct_answer'] as String?,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'category': instance.category,
      'difficulty': instance.difficulty,
      'question': instance.question,
      'correct_answer': instance.correctAnswer,
      'incorrect_answers': instance.answers,
    };
