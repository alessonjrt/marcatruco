import 'package:flutter/material.dart';
import 'package:marcatruco/models/match.dart';
import 'package:marcatruco/models/match_action.dart';
import 'package:marcatruco/models/team.dart';
import 'package:marcatruco/services/match_storage.dart';
import 'package:marcatruco/shared/enums/rise_mode.dart';

class ScoreBoardController extends ChangeNotifier {
  static const int maxPoints = 12;
  late Match match;

  final MatchStorage _matchStorage = MatchStorage();
  bool _isMatchCreated = false;

  ScoreBoardController({
    required Team teamA,
    required Team teamB,
  }) : match = Match(teamA: teamA, teamB: teamB, riseMode: RiseMode.none) {
    Match? lastUnfinishedMatch = _matchStorage.lastUnfinishedMatch;

    if (lastUnfinishedMatch != null) {
      match = lastUnfinishedMatch;
      _isMatchCreated = true;
    }
  }

  bool get hidden => match.teamA.score == 11 && match.teamB.score == 11;

  bool get isGameOver => match.isGameOver;

  void addPointTeamA(int value) {
    if (!_isMatchCreated) {
      _createMatchInStorage();
    }

    if (!match.teamA.hasWon) {
      match.teamA.addScore(value);
      if (value > 0) {
        _logAction(
          type: ActionType.add,
          team: match.teamA,
          points: value,
        );
        _updateMatchInStorage();
      }
      notifyListeners();
      updateRiseMode(RiseMode.none);
      _checkGameOver();
    }
  }

  void addPointTeamB(int value) {
    if (!_isMatchCreated) {
      _createMatchInStorage();
    }

    if (!match.teamB.hasWon) {
      match.teamB.addScore(value);
      if (value > 0) {
        _logAction(
          type: ActionType.add,
          team: match.teamB,
          points: value,
        );
        _updateMatchInStorage();
      }
      notifyListeners();
      updateRiseMode(RiseMode.none);
      _checkGameOver();
    }
  }

  void fold(
    Team foldingTeam,
    Team opposingTeam,
  ) {
    if (!_isMatchCreated) {
      _createMatchInStorage();
    }

    int foldValue = match.riseMode.value;

    Team winningTeam = opposingTeam;
    Team losingTeam = foldingTeam;

    if (!winningTeam.hasWon) {
      winningTeam.addScore(foldValue);

      if (foldValue > 0) {
        _logAction(
          type: ActionType.fold,
          team: winningTeam,
          otherTeam: losingTeam,
          points: foldValue,
        );
        _updateMatchInStorage();
      }

      updateRiseMode(RiseMode.none);
      notifyListeners();

      _checkGameOver();
    }
  }

  void subtractPointTeamA() {
    if (match.teamA.score > 0) {
      match.teamA.subtractScore(1);
      _logAction(
        type: ActionType.subtract,
        team: match.teamA,
        points: 1,
      );
      _updateMatchInStorage();
      notifyListeners();
    }
  }

  void subtractPointTeamB() {
    if (match.teamB.score > 0) {
      match.teamB.subtractScore(1);
      _logAction(
        type: ActionType.subtract,
        team: match.teamB,
        points: 1,
      );
      _updateMatchInStorage();
      notifyListeners();
    }
  }

  void updateTeamName(String teamId, String name) {
    if (teamId == match.teamA.id) {
      match.teamA.name = name;
    } else {
      match.teamB.name = name;
    }
    _updateMatchInStorage();
  }

  void _checkGameOver() {
    if (match.teamA.hasWon || match.teamB.hasWon) {
      match.isGameOver = true;
      match.endTime = DateTime.now();
      _updateMatchInStorage();
      notifyListeners();
    }
  }

  Future<void> resetAndDeleteMatch() async {
    if (_isMatchCreated) {
      _matchStorage.deleteMatch(match.id);
      _isMatchCreated = false;
    }

    Team newTeamA = Team(name: match.teamA.name);
    Team newTeamB = Team(name: match.teamB.name);
    match = Match(teamA: newTeamA, teamB: newTeamB, riseMode: RiseMode.none);

    notifyListeners();
  }

  void resetScores() {
    if (!match.isGameOver) {
      match.isGameOver = true;
      match.endTime = DateTime.now();
      _updateMatchInStorage();
    }

    Team newTeamA = Team(name: match.teamA.name);
    Team newTeamB = Team(name: match.teamB.name);
    match = Match(teamA: newTeamA, teamB: newTeamB, riseMode: RiseMode.none);

    _isMatchCreated = false;
    notifyListeners();
  }

  void updateRiseMode(RiseMode newMode) {
    match.riseMode = newMode;
    _updateMatchInStorage();
    notifyListeners();
  }

  void _updateMatchInStorage() {
    if (_isMatchCreated) {
      _matchStorage.updateMatch(match);
    }
  }

  void _createMatchInStorage() {
    _matchStorage.addMatch(match);
    _isMatchCreated = true;
  }

  void _logAction({
    required ActionType type,
    required Team team,
    Team? otherTeam,
    required int points,
  }) {
    MatchAction action = MatchAction(
      type: type,
      team: team,
      points: points,
      otherTeam: otherTeam,
      timestamp: DateTime.now(),
    );
    match.actions.add(action);
    _updateMatchInStorage();
    notifyListeners();
  }
}
