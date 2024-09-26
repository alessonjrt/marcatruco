// lib/features/history/history_controller.dart

import 'package:flutter/material.dart';
import 'package:cardmate/models/match.dart';
import 'package:cardmate/services/match_storage.dart';

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

  void deleteMatch(String id) {
    _matchStorage.deleteMatch(id);
    _matches = _matchStorage.matches;
    notifyListeners();
  }

  void clearHistory() {
    _matchStorage.clearMatches();
    _matches.clear();
    notifyListeners();
  }
}
