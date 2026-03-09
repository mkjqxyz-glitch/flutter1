class Question {
  final int id;
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'],
    );
  }
}