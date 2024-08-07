class CategoriesModel {
  CategoriesModel({
    List<TriviaCategories>? triviaCategories,
  }) : _triviaCategories = triviaCategories ?? [];

  CategoriesModel.fromJson(dynamic json)
      : _triviaCategories = (json['trivia_categories'] != null)
      ? List<TriviaCategories>.from(
    json['trivia_categories'].map((category) => TriviaCategories.fromJson(category)),
  )
      : [];

  final List<TriviaCategories> _triviaCategories;

  CategoriesModel copyWith({
    List<TriviaCategories>? triviaCategories,
  }) =>
      CategoriesModel(
        triviaCategories: triviaCategories ?? _triviaCategories,
      );

  List<TriviaCategories> get triviaCategories => _triviaCategories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_triviaCategories.isNotEmpty) {
      map['trivia_categories'] =
          _triviaCategories.map((v) => v.toJson()).toList();
    }
    return map;
  }
}



class TriviaCategories {
  TriviaCategories({
    required this.id,
    required this.name,
  });

  TriviaCategories.fromJson(dynamic json)
      : id = json['id'],
        name = json['name'];

  final num id;
  final String name;

  TriviaCategories copyWith({
    num? id,
    String? name,
  }) =>
      TriviaCategories(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
