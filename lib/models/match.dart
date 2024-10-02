import 'package:marcatruco/models/team.dart';
import 'package:marcatruco/models/match_action.dart';
import 'package:marcatruco/shared/enums/rise_mode.dart';
import 'package:uuid/uuid.dart';

class Match {
  String id;
  Team teamA;
  Team teamB;
  bool isGameOver;
  DateTime startTime;
  DateTime? endTime;
  RiseMode riseMode;
  List<MatchAction> actions;

  Match({
    String? id,
    required this.teamA,
    required this.teamB,
    this.isGameOver = false,
    DateTime? startTime,
    this.endTime,
    required this.riseMode,
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
        'riseMode': riseMode.name, 
        'actions': actions.map((action) => action.toJson()).toList(),
      };

  factory Match.fromJson(Map<String, dynamic> json) {
  

    return Match(
      id: json['id'],
      teamA: Team.fromJson(json['teamA']),
      teamB: Team.fromJson(json['teamB']),
      isGameOver: json['isGameOver'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      riseMode: json['riseMode'] != null ? RiseMode.fromString(json['riseMode']) : RiseMode.none, // Desserializa riseMode a partir da string
      actions: (json['actions'] as List<dynamic>?)
              ?.map((actionJson) => MatchAction.fromJson(actionJson))
              .toList() ??
          [],
    );
  }
}
