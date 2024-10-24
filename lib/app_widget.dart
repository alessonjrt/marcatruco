import 'package:flutter/material.dart';
import 'package:marcatruco/routes/app_routes.dart';
import 'package:marcatruco/shared/theme/app_theme.dart';

class MarcaTruco extends StatelessWidget {
  const MarcaTruco({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.menu,
      routes: AppRoutes.pages,
    );
  }
}
