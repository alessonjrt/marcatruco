import 'package:flutter/material.dart';
import 'package:marcatruco/shared/assets/assets.dart';

class MarcaTrucoLogo extends StatelessWidget {
  const MarcaTrucoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.suits,
          height: MediaQuery.of(context).size.height * 0.05,
          color: Colors.red,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
        ),
        Text(
          'marcatruco',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
