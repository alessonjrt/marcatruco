import 'package:flutter/material.dart';
import 'package:marcatruco/shared/widgets/logo.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMenuButton(
                      context,
                      title: 'Jogar',
                      icon: Icons.play_arrow_rounded,
                      route: '/score_board',
                    ),
                    const SizedBox(width: 10),
                    _buildMenuButton(
                      context,
                      title: 'Histórico',
                      icon: Icons.history,
                      route: '/history',
                    ),
                    // Você pode descomentar e ajustar este botão se necessário
                    // const SizedBox(width: 10),
                    // _buildMenuButton(
                    //   context,
                    //   title: 'Opções',
                    //   icon: Icons.settings,
                    //   route: '/options',
                    // ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    double width = MediaQuery.of(context).size.width * 0.28;
    double height = MediaQuery.of(context).size.height * 0.11;

    return Container(
      width: width + 1,
      height: height + 1,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ],
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).scaffoldBackgroundColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(route),
          child: Container(
            padding: const EdgeInsets.all(4),
            width: width,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.transparent),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
