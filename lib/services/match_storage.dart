// lib/services/match_storage.dart

import 'dart:convert';
import 'package:marcatruco/models/match.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MatchStorage {
  static final MatchStorage _instance = MatchStorage._internal();

  factory MatchStorage() {
    return _instance;
  }

  MatchStorage._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _matchesKey = 'matches_map';

  Map<String, Match> _matches = {};

  Map<String, Match> get matches => Map.unmodifiable(_matches);

  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      await _loadMatchesFromStorage();
      _isInitialized = true;
    }
  }

  Future<void> _loadMatchesFromStorage() async {
    String? matchesJson = await _secureStorage.read(key: _matchesKey);
    if (matchesJson != null) {
      Map<String, dynamic> matchesMapJson = jsonDecode(matchesJson);
      _matches = matchesMapJson.map((key, value) =>
          MapEntry(key, Match.fromJson(value as Map<String, dynamic>)));

      _matches = Map.fromEntries(_matches.entries.toList()
        ..sort((a, b) => b.value.startTime.compareTo(a.value.startTime)));

      _matches.forEach((key, match) {
        match.actions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      });
    } else {
      _matches = {};
    }
  }

  void addMatch(Match match) {
    _matches[match.id] = match;

    _matches = Map.fromEntries(_matches.entries.toList()
      ..sort((a, b) => b.value.startTime.compareTo(a.value.startTime)));

    match.actions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    _saveMatchesToStorage();
  }

  void updateMatch(Match match) {
    if (_matches.containsKey(match.id)) {
      _matches[match.id] = match;

      _matches = Map.fromEntries(_matches.entries.toList()
        ..sort((a, b) => b.value.startTime.compareTo(a.value.startTime)));

      match.actions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      _saveMatchesToStorage();
    }
  }

  Match? deleteMatch(String id) {
    if (_matches.containsKey(id)) {
      Match? removedMatch = _matches.remove(id);
      _saveMatchesToStorage();
      return removedMatch;
    }
    return null;
  }

  Match? getMatchById(String id) {
    return _matches[id];
  }

  Match? get lastUnfinishedMatch {
    try {
      return _matches.values.firstWhere(
        (match) => !match.isGameOver,
      );
    } catch (e) {
      return null;
    }
  }

  void clearMatches() {
    _matches.clear();
    _saveMatchesToStorage();
  }

  void _saveMatchesToStorage() {
    Future.microtask(() async {
      Map<String, dynamic> matchesMapJson =
          _matches.map((key, match) => MapEntry(key, match.toJson()));
      await _secureStorage.write(
        key: _matchesKey,
        value: jsonEncode(matchesMapJson),
      );
    });
  }
}
