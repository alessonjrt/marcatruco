import 'package:flutter/material.dart';

class MarcaTrucoLogo extends StatelessWidget {
  const MarcaTrucoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/suits.png', height: MediaQuery.of(context).size.height * 0.05, color: Colors.red, ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
        const Text(
          'marcatruco',
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
      ],
    );
  }
}
