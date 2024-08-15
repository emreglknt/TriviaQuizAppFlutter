import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:meta/meta.dart';
import '../dataModel/categories/categories_model.dart';
import '../dataModel/quizmodel/QuizModel.dart';
import '../resources/apiRepo.dart';
import '../utils/utils.dart';


part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    final FlutterTts flutterTts = FlutterTts();

    on<FetchCategories>((event, emit) async {
      try {
        emit(CategoryLoading());
        final categoryModel = await _apiRepository.fetchTriviaCategories();
        emit(CategorySuccess(categoryModel.triviaCategories));
      } on NetworkError {
        emit(CategoryError("Failed to fetch data. is your device online?"));
      }
    });


    on<FetchQuizQuestions>((event, emit) async {
      try {
        emit(QuizLoading());
        var diff = event.difficulty.toStr();
        var amount = event.amount.toStr();
        var category = event.category;
        var generatedUrl = "https://opentdb.com/api.php?amount=$amount&difficulty=$diff&category=$category&type=multiple";

        final quizModel = await _apiRepository.fetchQuizQuestions(generatedUrl);
        // Ensure quizModel has results
        if (quizModel.results.isNotEmpty) {
          // Shuffle answers for each question
          for (var result in quizModel.results) {
            result.incorrectAnswers.add(result.correctAnswer);
            result.incorrectAnswers.shuffle(Random());
          }
          emit(QuizSuccess(quizModel, 0));
        } else {
          emit(QuizError("No quiz questions found."));
        }
      } on NetworkError {
        emit(QuizError("Failed to fetch data. Is your device online?"));
      }
    });


    on<NextQuestionEvent>((event, emit) {
      final currentState = state;
      if (currentState is QuizSuccess) {
        final nextIndex = currentState.currentQuestionIndex + 1;
        if (nextIndex < currentState.quizModel.results.length) {
          emit(QuizSuccess(currentState.quizModel, nextIndex));
        } else {
          // Tüm sorular tamamlandı
          // İsteğe bağlı olarak bir son durumu ekleyebilirsiniz
        }
      }
    });


    on<SpeakText>((event, emit) async {
      final currentState = state;
      if (currentState is QuizSuccess) {
        try {
          await flutterTts.setLanguage("en-US");
          await flutterTts.setPitch(1.0);
          await flutterTts.speak(event.text);
          emit(currentState);
        } catch (e) {
          emit(QuizError("Failed to speak text"));
        }
      }
    });





  }



}
