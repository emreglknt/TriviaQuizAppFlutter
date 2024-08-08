part of 'quiz_bloc.dart';

@immutable
sealed class QuizState {}

final class QuizInitial extends QuizState {}


class CategoryLoading extends QuizState {}

class CategorySuccess extends QuizState{
  final List<TriviaCategories> categories;
  CategorySuccess(this.categories);
}


class CategoryError extends QuizState {
  final String? message;
  CategoryError(this.message);
}






class QuizLoading extends QuizState {}

class QuizSuccess extends QuizState {
  final QuizModel quizModel;
  final int currentQuestionIndex;

  QuizSuccess(this.quizModel,this.currentQuestionIndex);
  @override
  List<Object> get props => [quizModel, currentQuestionIndex];
}

class QuizError extends QuizState {
  final String message;

  QuizError(this.message);

  @override
  List<Object> get props => [message];
}











class TtsInitial extends QuizState {}

class TtsSpeaking extends QuizState {}

class TtsCompleted extends QuizState {}

class TtsError extends QuizState{
  final String message;

  TtsError(this.message);

  @override
  List<Object> get props => [message];
}



