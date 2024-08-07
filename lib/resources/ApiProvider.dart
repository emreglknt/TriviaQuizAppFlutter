import 'package:dio/dio.dart';
import '../dataModel/categories/categories_model.dart';
import '../dataModel/quizmodel/QuizModel.dart';
import '../utils/utils.dart';


class ApiProvider {
  final Dio _dio = Dio();


  Future<CategoriesModel> fetchTriviaCategories() async {
    try {
      Response response = await _dio.get(CATEGORY_URL);
      return CategoriesModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");

      return CategoriesModel(triviaCategories: []);
    }
  }



  Future<QuizModel>fetchQuizQuestions(String generatedUrl)async{
    try{
      Response quizResponse = await _dio.get(generatedUrl);
      return QuizModel.fromJson(quizResponse.data);
    }catch(error,stacktrace){
      print("Exception occurred: $error stackTrace: $stacktrace");
      return QuizModel(results:[], responseCode: 0);
    }
  }





}