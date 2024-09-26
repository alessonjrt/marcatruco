import 'package:cardmate/app_widget.dart';
import 'package:cardmate/services/match_storage.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MatchStorage().init();

  runApp(const CardMate());
}
