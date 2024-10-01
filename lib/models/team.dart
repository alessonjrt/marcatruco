import 'package:marcatruco/features/score_board/score_board_controller.dart';
import 'package:uuid/uuid.dart';

class Team {
  final String id;
  String name;
  int score;

  Team({
    String? id,
    required this.name,
    this.score = 0,
  }) : id = id ?? const Uuid().v4();

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
        'id': id,
        'name': name,
        'score': score,
      };

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json['id'],
        name: json['name'],
        score: json['score'],
      );
}
