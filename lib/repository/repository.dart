import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_demo_hook/model/question.dart';
import 'package:flutter_demo_hook/repository/base_quiz_responsitory.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_utils/app_const.dart';
import '../core/api_failure.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final quizRepositoryProvider =
    Provider<QuizReponsitory>((ref) => QuizReponsitory(ref.read));

class QuizReponsitory extends BaseQuizRepository {
  final Reader _read;
  QuizReponsitory(this._read);

  @override
  Future<List<Question>> getQuestions({
    required int numQuestions,
    required int categoryId,
    required Difficulty difficulty,
  }) async {
    try {
      final queryParameters = {
        'type': 'multiple',
        'amount': numQuestions,
        'category': categoryId,
      };

      if (difficulty != Difficulty.any) {
        queryParameters.addAll(
          {'difficulty': EnumToString.convertToString(difficulty)},
        );
      }
      print("parameter");
      print(queryParameters);
      final response = await _read(dioProvider).get(
        'https://opentdb.com/api.php',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final results = List<Map<String, dynamic>>.from(data['results'] ?? []);
        if (results.isNotEmpty) {
          return results.map((e) => Question.fromJson(e)).toList();
        }
      }
      return [];
    } on DioError catch (err) {
      print(err);
      throw Failure(
        message: err.response?.statusMessage ?? 'Something went wrong!',
      );
    } on SocketException catch (err) {
      print(err);
      throw const Failure(message: 'Please check your connection.');
    }
  }
}
