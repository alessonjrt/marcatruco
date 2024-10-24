import 'package:flutter/material.dart';
import 'package:marcatruco/shared/assets/assets.dart';

class MarcaTrucoLogo extends StatelessWidget {
  const MarcaTrucoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.logo,
      height: MediaQuery.of(context).size.height * 0.1,
    );
  }
}
