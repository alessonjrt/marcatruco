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
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    _buildMenuButton(
                      context,
                      title: 'Histórico',
                      icon: Icons.history,
                      route: '/history',
                      color: Colors.white,
                    ),
                    // const SizedBox(width: 10),
                    // _buildMenuButton(
                    //   context,
                    //   title: 'Opções',
                    //   icon: Icons.settings,
                    //   route: '/history',
                    //   color: Colors.white,
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
    required Color color,
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
            Colors.grey.shade300,
            Colors.grey.shade600,
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
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade300,
                      Colors.grey.shade600,
                    ],
                  ).createShader(bounds),
                  child: Icon(
                    icon,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade300,
                      Colors.grey.shade600,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.white, // Cor base antes de aplicar o degradê
                    ),
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
