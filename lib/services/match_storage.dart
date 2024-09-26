import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:cardmate/models/match.dart';

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
    } else {
      _matches = {};
    }
  }

  void addMatch(Match match) {
    _matches[match.id] = match;
    _saveMatchesToStorage();
  }

  void updateMatch(Match match) {
    if (_matches.containsKey(match.id)) {
      _matches[match.id] = match;
      _saveMatchesToStorage();
    }
  }

  void deleteMatch(String id) {
    if (_matches.containsKey(id)) {
      _matches.remove(id);
      _saveMatchesToStorage();
    }
  }

  Match? getMatchById(String id) {
    return _matches[id];
  }

  void clearMatches() {
    _matches.clear();
    _saveMatchesToStorage();
  }

  void _saveMatchesToStorage() {
    Future.microtask(() async {
      Map<String, dynamic> matchesMapJson = _matches.map(
          (key, match) => MapEntry(key, match.toJson()));
      await _secureStorage.write(
        key: _matchesKey,
        value: jsonEncode(matchesMapJson),
      );
    });
  }
}
