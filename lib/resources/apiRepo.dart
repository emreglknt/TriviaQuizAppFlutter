
import 'package:quiz_time/dataModel/quizmodel/QuizModel.dart';
import 'package:quiz_time/resources/ApiProvider.dart';

import '../dataModel/categories/categories_model.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<CategoriesModel> fetchTriviaCategories() {
    return _provider.fetchTriviaCategories();
  }

  // get quiz question function

  Future<QuizModel> fetchQuizQuestions(String generatedUrl) {
    return _provider.fetchQuizQuestions(generatedUrl);
  }



}

class NetworkError extends Error {}