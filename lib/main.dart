import 'package:marcatruco/app_widget.dart';
import 'package:marcatruco/services/match_storage.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MatchStorage().init();

  runApp(const MarcaTruco());
}
