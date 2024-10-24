import 'package:flutter/material.dart';
import 'package:marcatruco/routes/app_routes.dart';
import 'package:marcatruco/shared/widgets/logo.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryButtonColor = Theme.of(context).colorScheme.primary;
    final Color secondaryButtonColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MarcaTrucoLogo(),
              const SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: primaryButtonColor,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.scoreBoard),
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Jogar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: secondaryButtonColor,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.history),
                    icon: const Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Histórico',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
