import 'package:marcatruco/models/team.dart';

enum ActionType { add, subtract, fold }

class MatchAction {
  final ActionType type;
  final Team team; 
  final Team? otherTeam; 
  final int points;
  final DateTime timestamp;

  MatchAction({
    required this.type,
    required this.team,
    this.otherTeam,
    required this.points,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'type': type.toString().split('.').last, 
        'team': team.toJson(),
        'otherTeam': otherTeam?.toJson(),
        'points': points,
        'timestamp': timestamp.toIso8601String(),
      };

  factory MatchAction.fromJson(Map<String, dynamic> json) {
    ActionType parsedType;

    switch (json['type']) {
      case 'add':
        parsedType = ActionType.add;
        break;
      case 'subtract':
        parsedType = ActionType.subtract;
        break;
      case 'fold':
        parsedType = ActionType.fold;
        break;
      default:
        throw ArgumentError('Unknown action type: ${json['type']}');
    }

    return MatchAction(
      type: parsedType,
      team: Team.fromJson(json['team']),
      otherTeam: json['otherTeam'] != null ? Team.fromJson(json['otherTeam']) : null,
      points: json['points'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
