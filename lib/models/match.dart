
import 'package:marcatruco/models/team.dart';
import 'package:marcatruco/models/match_action.dart';
import 'package:uuid/uuid.dart';

class Match {
  String id;
  Team teamA;
  Team teamB;
  bool isGameOver;
  DateTime startTime;
  DateTime? endTime;
  List<MatchAction> actions; 
  Match({
    String? id,
    required this.teamA,
    required this.teamB,
    this.isGameOver = false,
    DateTime? startTime,
    this.endTime,
    List<MatchAction>? actions,
  })  : id = id ?? const Uuid().v4(),
        startTime = startTime ?? DateTime.now(),
        actions = actions ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'teamA': teamA.toJson(),
        'teamB': teamB.toJson(),
        'isGameOver': isGameOver,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'actions': actions.map((action) => action.toJson()).toList(),
      };

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        id: json['id'],
        teamA: Team.fromJson(json['teamA']),
        teamB: Team.fromJson(json['teamB']),
        isGameOver: json['isGameOver'],
        startTime: DateTime.parse(json['startTime']),
        endTime:
            json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
        actions: (json['actions'] as List<dynamic>?)
                ?.map((actionJson) => MatchAction.fromJson(actionJson))
                .toList() ??
            [],
      );
}
