import 'package:flutter/material.dart';



class ScoreBoardController extends ChangeNotifier {
  int _team1Score = 0;
  int _team2Score = 0;

  int get team1Score => _team1Score;
  int get team2Score => _team2Score;

  void addPointTeam1() {
    if (_team1Score < 30) { 
      _team1Score++;
      notifyListeners();
    }
  }

  void addPointTeam2() {
    if (_team2Score < 30) {
      _team2Score++;
      notifyListeners();
    }
  }

  void subtractPointTeam1() {
    if (_team1Score > 0) {
      _team1Score--;
      notifyListeners();
    }
  }

  void subtractPointTeam2() {
    if (_team2Score > 0) {
      _team2Score--;
      notifyListeners();
    }
  }


}
