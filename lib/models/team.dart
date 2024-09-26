import 'package:cardmate/features/score_board/score_board_controller.dart';

class Team {
  final String name;
  int score;

  Team({
    required this.name,
    this.score = 0,
  });

  void addScore(int value) {
    score += value;
    if (score > ScoreBoardController.maxPoints) {
      score = ScoreBoardController.maxPoints;
    }
  }

  void subtractScore(int value) {
    score -= value;
    if (score < 0) {
      score = 0;
    }
  }

  bool get hasWon => score >= ScoreBoardController.maxPoints;
  bool get isInHandOfEleven => score == 11;

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
      };

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        name: json['name'],
        score: json['score'],
      );
}
