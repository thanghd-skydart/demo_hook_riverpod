import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo_hook/repository/repository.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_utils/app_const.dart';
import '../controllers/quiz_controller.dart';
import '../controllers/quiz_state.dart';
import '../core/api_failure.dart';
import '../model/question.dart';
import '../widget/custom_button.dart';
import '../widget/quiz_error.dart';
import '../widget/quiz_questions.dart';
import '../widget/quiz_result.dart';

final quizQuestionsProvider = FutureProvider.autoDispose<List<Question>>(
  (ref) async {
    var store = ref.watch(quizRepositoryProvider);
    var listQuestion = await store.getQuestions(
      numQuestions: 5,
      categoryId: Random().nextInt(24) + 9,
      difficulty: Difficulty.medium,
    );
    for (var item in listQuestion) {
      print("bố may");
      print(item.toJson());
      item.answers!.add(item.correctAnswer!);
    }
    return listQuestion as List<Question>;
  },
);

class QuizScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizQuestions = ref.watch(quizQuestionsProvider);
    final pageController = usePageController();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD4418E), Color(0xFF0652C5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: quizQuestions.when(
          data: (questions) =>
              BuildBody(pageController: pageController, questions: questions),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => QuizError(
            message: error is Failure ? error.message : 'Something went wrong!',
            onTap: () {
              ref.refresh(quizRepositoryProvider);
            },
          ),
        ),
        bottomSheet: quizQuestions.maybeWhen(
          data: (questions) {
            final quizState = ref.watch(quizControllerProvider);
            if (!quizState.answer) return const SizedBox.shrink();
            return CustomButton(
              title: pageController.page!.toInt() + 1 < questions.length
                  ? 'Next Question'
                  : 'See Results',
              onTap: () {
                ref
                    .read(quizControllerProvider.notifier)
                    .nextQuestion(questions, pageController.page!.toInt());
                if (pageController.page!.toInt() + 1 < questions.length) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.linear,
                  );
                }
              },
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class BuildBody extends ConsumerWidget {
  const BuildBody(
      {Key? key, required this.pageController, required this.questions})
      : super(key: key);
  final PageController pageController;
  final List<Question> questions;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (questions.isEmpty)
      // ignore: curly_braces_in_flow_control_structures
      return QuizError(
        message: 'No questions found.',
        onTap: () {
          ref.refresh(quizRepositoryProvider);
          ref.read(quizControllerProvider.notifier).reset();
        },
      );

    final quizState = ref.read(quizControllerProvider);
    return quizState.status == QuizStatus.complete
        ? QuizResults(
            state: quizState,
            questions: questions,
            onTap: () {
              ref.refresh(quizRepositoryProvider);
              ref.read(quizControllerProvider.notifier).reset();
            },
          )
        : QuizQuestions(
            pageController: pageController,
            state: quizState,
            questions: questions,
          );
  }
}
