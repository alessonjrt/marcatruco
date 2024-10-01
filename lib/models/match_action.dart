import 'package:marcatruco/models/team.dart';

enum ActionType { add, subtract }

class MatchAction {
  final ActionType type;
  final Team team; 
  final int points;
  final DateTime timestamp;

  MatchAction({
    required this.type,
    required this.team,
    required this.points,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'type': type.toString().split('.').last, 
        'team': team.toJson(),
        'points': points,
        'timestamp': timestamp.toIso8601String(),
      };

  factory MatchAction.fromJson(Map<String, dynamic> json) => MatchAction(
        type: json['type'] == 'add' ? ActionType.add : ActionType.subtract,
        team: Team.fromJson(json['team']),
        points: json['points'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
