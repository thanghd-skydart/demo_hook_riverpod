import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  String? category;
  String? difficulty;
  String? question;
  @JsonKey(name: 'correct_answer')
  String? correctAnswer;
  @JsonKey(name: 'incorrect_answers')
  List<String>? answers;

  Question(this.category, this.difficulty, this.question, this.answers,
      this.correctAnswer);

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
