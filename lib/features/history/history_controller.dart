import 'package:flutter/material.dart';
import 'package:marcatruco/models/match.dart';
import 'package:marcatruco/services/match_storage.dart';

class HistoryController extends ChangeNotifier {
  final MatchStorage _matchStorage = MatchStorage();
  Map<String, Match> _matches = {};

  Map<String, Match> get matches => _matches;

  HistoryController() {
    loadMatches();
  }

  Future<void> loadMatches() async {
    _matches = _matchStorage.matches;
    notifyListeners();
  }

  Match? deleteMatch(String id) {
    _matchStorage.deleteMatch(id);
    _matches = _matchStorage.matches;
    notifyListeners();
    return null;
  }

  void clearHistory() {
    _matchStorage.clearMatches();
    _matches.clear();
    notifyListeners();
  }
}
