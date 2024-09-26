import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(children: [

            const Text(
              'Bem-vindo ao CardMate',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black26,
                    offset: Offset(3.0, 3.0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
            children: [
              _buildMenuButton(
                context,
                title: 'Jogar',
                icon: Icons.play_arrow_rounded,
                route: '/score_board',
                color: Colors.white,
              ),
              const SizedBox(width: 20),
              _buildMenuButton(
                context,
                title: 'Histórico',
                icon: Icons.history,
                route: '/history',
                color: Colors.white,
              ),
            ],
          ),
          ],)
        ),
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
    return Material(
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        child: Container(
          padding: const EdgeInsets.all(4),
          width: 110,
          height: 85,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.transparent
            ),
            borderRadius: BorderRadius.circular(4),
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     Colors.grey.shade300,
            //     Colors.grey.shade600,
            //   ],
            // ),
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
                  color: Colors
                      .white, // Define a cor base antes de aplicar o degradê
                ),
              ),
              const SizedBox(height: 20),
              // Texto com degradê prateado
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
                    color: Colors.white, // Cor base antes de aplicar o degradê
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
