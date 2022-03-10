import 'package:flutter/material.dart';
import 'package:flutter_demo_hook/model/question.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../controllers/quiz_state.dart';
import 'custom_button.dart';

class QuizResults extends HookWidget {
  final QuizState state;
  final List<Question> questions;
  final VoidCallback? onTap;
  const QuizResults(
      {Key? key, required this.state, required this.questions, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${state.correct.length} / ${questions.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          'CORRECT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40.0),
        CustomButton(title: 'New Quiz', onTap: onTap!),
      ],
    );
  }
}
