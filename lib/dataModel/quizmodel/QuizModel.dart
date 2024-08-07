class QuizModel {
  num _responseCode = 0;
  List<Results> _results = [];

  QuizModel({
    required num responseCode,
    required List<Results> results,
  }) {
    _responseCode = responseCode;
    _results = results;
  }

  QuizModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((questionObject) {
        _results.add(Results.fromJson(questionObject));
      });
    }
  }

  QuizModel copyWith({
    num? responseCode,
    List<Results>? results,
  }) => QuizModel(
    responseCode: responseCode ?? _responseCode,
    results: results ?? _results,
  );

  num get responseCode => _responseCode;
  List<Results> get results => _results;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    if (_results != null) {
      map['results'] = _results.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Results {
  String _type = "";
  String _difficulty = "";
  String _category = "";
  String _question = "";
  String _correctAnswer = "";
  List<String> _incorrectAnswers = [];

  Results({
    required String type,
    required String difficulty,
    required String category,
    required String question,
    required String correctAnswer,
    required List<String> incorrectAnswers,
  }) {
    _type = type;
    _difficulty = difficulty;
    _category = category;
    _question = question;
    _correctAnswer = correctAnswer;
    _incorrectAnswers = incorrectAnswers;
  }

  Results.fromJson(dynamic json) {
    _type = json['type'];
    _difficulty = json['difficulty'];
    _category = json['category'];
    _question = json['question'];
    _correctAnswer = json['correct_answer'];
    _incorrectAnswers = json['incorrect_answers'] != null
        ? json['incorrect_answers'].cast<String>()
        : [];
  }

  Results copyWith({
    String? type,
    String? difficulty,
    String? category,
    String? question,
    String? correctAnswer,
    List<String>? incorrectAnswers,
  }) => Results(
    type: type ?? _type,
    difficulty: difficulty ?? _difficulty,
    category: category ?? _category,
    question: question ?? _question,
    correctAnswer: correctAnswer ?? _correctAnswer,
    incorrectAnswers: incorrectAnswers ?? _incorrectAnswers,
  );

  String get type => _type;
  String get difficulty => _difficulty;
  String get category => _category;
  String get question => _question;
  String get correctAnswer => _correctAnswer;
  List<String> get incorrectAnswers => _incorrectAnswers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['difficulty'] = _difficulty;
    map['category'] = _category;
    map['question'] = _question;
    map['correct_answer'] = _correctAnswer;
    map['incorrect_answers'] = _incorrectAnswers;
    return map;
  }
}
