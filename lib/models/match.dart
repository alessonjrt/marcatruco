import 'package:marcatruco/models/team.dart';
import 'package:uuid/uuid.dart';

class Match {
  String id;
  Team teamA;
  Team teamB;
  bool isGameOver;
  DateTime startTime;
  DateTime? endTime;

  Match({
    String? id,
    required this.teamA,
    required this.teamB,
    this.isGameOver = false,
    DateTime? startTime,
    this.endTime,
  })  : id = id ?? const Uuid().v4(),
        startTime = startTime ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'teamA': teamA.toJson(),
        'teamB': teamB.toJson(),
        'isGameOver': isGameOver,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
      };

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        id: json['id'],
        teamA: Team.fromJson(json['teamA']),
        teamB: Team.fromJson(json['teamB']),
        isGameOver: json['isGameOver'],
        startTime: DateTime.parse(json['startTime']),
        endTime:
            json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      );
}
