import 'package:flutter/material.dart';

import '../features/history/history_screen.dart';
import '../features/menu/menu_screen.dart';
import '../features/score_board/score_board_screen.dart';
import '../features/share_result/share_result_screen.dart';

class AppRoutes {
  static const String scoreBoard = '/score_board';
  static const String history = '/history';
  static const String menu = '/menu';
  static const String shareResult = '/share_result';

  // Mapa de rotas utilizando as constantes
  static final Map<String, Widget Function(BuildContext)> pages = {
    scoreBoard: (BuildContext context) => const ScoreBoardScreen(),
    history: (BuildContext context) => const HistoryScreen(),
    menu: (BuildContext context) => const MenuScreen(),
    shareResult: (BuildContext context) => const ShareResultScreen(),
  };
}
