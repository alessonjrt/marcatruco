import 'package:cardmate/models/match.dart';
import 'package:cardmate/models/team.dart';
import 'package:cardmate/services/match_storage.dart';
import 'package:cardmate/shared/enums/rise_mode.dart';
import 'package:flutter/material.dart';

class ScoreBoardController extends ChangeNotifier {
  static const int maxPoints = 12;
  Match match;
  RiseMode riseMode = RiseMode.none;

  final MatchStorage _matchStorage = MatchStorage();

  ScoreBoardController({
    required Team teamA,
    required Team teamB,
  }) : match = Match(teamA: teamA, teamB: teamB) {
    _matchStorage.addMatch(match);
  }

  bool get hidden => match.teamA.score == 11 && match.teamB.score == 11;

  bool get isGameOver => match.isGameOver;

  void addPointTeamA(int value) {
    if (!match.teamA.hasWon) {
      match.teamA.addScore(value);
      _updateMatchInStorage();
      notifyListeners();
      updateRiseMode(RiseMode.none);
      _checkGameOver();
    }
  }

  void addPointTeamB(int value) {
    if (!match.teamB.hasWon) {
      match.teamB.addScore(value);
      _updateMatchInStorage();
      notifyListeners();
      updateRiseMode(RiseMode.none);
      _checkGameOver();
    }
  }

  void subtractPointTeamA() {
    if (match.teamA.score > 0) {
      match.teamA.subtractScore(1);
      _updateMatchInStorage();
      notifyListeners();
    }
  }

  void subtractPointTeamB() {
    if (match.teamB.score > 0) {
      match.teamB.subtractScore(1);
      _updateMatchInStorage();
      notifyListeners();
    }
  }

  void _checkGameOver() {
    if (match.teamA.hasWon || match.teamB.hasWon) {
      match.isGameOver = true;
      match.endTime = DateTime.now();
      _updateMatchInStorage();
      notifyListeners();
    }
  }

  void resetScores() {
    match.teamA.score = 0;
    match.teamB.score = 0;
    match.isGameOver = false;
    match.startTime = DateTime.now();
    match.endTime = null;
    _updateMatchInStorage();
    notifyListeners();
  }

  void updateRiseMode(RiseMode newMode) {
    riseMode = newMode;
    notifyListeners();
  }

  void _updateMatchInStorage() {
    _matchStorage.updateMatch(match);
  }
}
