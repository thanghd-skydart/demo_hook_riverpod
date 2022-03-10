import 'package:flutter_demo_hook/controllers/quiz_state.dart';
import 'package:flutter_demo_hook/model/question.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final quizControllerProvider =
    StateNotifierProvider.autoDispose<QuizController, QuizState>(
  (ref) => QuizController(),
);

class QuizController extends StateNotifier<QuizState> {
  QuizController() : super(QuizState.initial());
  void submitAnswer(Question currentQuestion, String ansewer) {
    if (state.answer) return;
    if (currentQuestion.correctAnswer == ansewer) {
      state = state.copyWith(
          selectedAnswer: ansewer,
          correct: state.correct..add(currentQuestion),
          status: QuizStatus.correct);
    } else if (currentQuestion.correctAnswer != ansewer) {
      state = state.copyWith(
          selectedAnswer: ansewer,
          inCorrect: state.inCorrect..add(currentQuestion),
          status: QuizStatus.incorrect);
    }
  }

  void nextQuestion(List<Question> question, int currentIndex) {
    state = state.copyWith(
        selectedAnswer: "",
        status: currentIndex + 1 < question.length
            ? QuizStatus.initial
            : QuizStatus.complete);
  }

  void reset() {
    state = QuizState.initial();
  }
}
