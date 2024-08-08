part of 'quiz_bloc.dart';

@immutable
abstract class QuizEvent extends Equatable {
  const QuizEvent();
  @override
  List<Object> get props => [];
}


class FetchCategories extends QuizEvent {}

class FetchQuizQuestions extends QuizEvent {
  final Difficulty difficulty;
  final QuestionAmount amount;
  final String category;

  const FetchQuizQuestions({
    required this.difficulty,
    required this.amount,
    required this.category,
  });

  @override
  List<Object> get props => [difficulty, amount, category];
}


class NextQuestionEvent extends QuizEvent {}

class SpeakText extends QuizEvent {
  final String text;

  const SpeakText(this.text);

  @override
  List<Object> get props => [text];
}