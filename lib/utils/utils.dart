import 'package:html/parser.dart';

enum Difficulty { easy, medium, hard }

extension DifficultyExtension on Difficulty {
  String toStr() {
    switch (this) {
      case Difficulty.easy:
        return 'easy';
      case Difficulty.medium:
        return 'medium';
      case Difficulty.hard:
        return 'hard';
    }
  }
}

enum QuestionAmount { five, ten, fifteen, twenty }

extension QuestionAmountExtension on QuestionAmount {
  String toStr() {
    switch (this) {
      case QuestionAmount.five:
        return '5';
      case QuestionAmount.ten:
        return '10';
      case QuestionAmount.fifteen:
        return '15';
      case QuestionAmount.twenty:
        return '20';
    }
  }
}

final String CATEGORY_URL = 'https://opentdb.com/api_category.php';
final String BASE_URL = 'https://opentdb.com/api.php';

String decodeHtml(String htmlString) {
  var document = parse(htmlString);
  return document.body?.text ?? htmlString;
}


