import 'package:equatable/equatable.dart';
import 'package:flutter_demo_hook/model/question.dart';
import 'package:meta/meta.dart';

enum QuizStatus { initial, correct, incorrect, complete }

class QuizState extends Equatable {
  final String selectedAnswer;
  List<Question> correct;
  List<Question> inCorrect;
  final QuizStatus status;

  bool get answer =>
      status == QuizStatus.incorrect || status == QuizStatus.correct;

  QuizState(
      {required this.selectedAnswer,
      required this.correct,
      required this.inCorrect,
      required this.status});

  factory QuizState.initial() {
    return QuizState(
      selectedAnswer: '',
      correct: [],
      inCorrect: [],
      status: QuizStatus.initial,
    );
  }
  @override
  List<Object> get props => [
        selectedAnswer,
        correct,
        inCorrect,
        status,
      ];

  QuizState copyWith({
    String? selectedAnswer,
    List<Question>? correct,
    List<Question>? inCorrect,
    QuizStatus? status,
  }) {
    return QuizState(
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      correct: correct ?? this.correct,
      inCorrect: inCorrect ?? this.inCorrect,
      status: status ?? this.status,
    );
  }
}
