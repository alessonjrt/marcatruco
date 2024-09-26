import 'package:cardmate/features/score_board/score_board_screen.dart';
import 'package:cardmate/features/share_result/share_result_screen.dart';
import 'package:cardmate/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CardMate extends StatelessWidget {
  const CardMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const ScoreBoardScreen(),
        '/share_result' : (context) => const ShareResultScreen()
      },
    );
  }
}