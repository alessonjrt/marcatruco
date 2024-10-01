import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marcatruco/shared/assets/assets.dart';
import 'package:audioplayers/audioplayers.dart';

class Duck extends StatefulWidget {
  final double? width;
  final double? height;
  const Duck({super.key,  this.width,  this.height});

  @override
  State<Duck> createState() => _DuckState();
}

class _DuckState extends State<Duck> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 0.05)
        .chain(
          CurveTween(curve: Curves.elasticIn),
        )
        .animate(_controller);
  }

  Future<void> _startShake() async {
    _audioPlayer.play(AssetSource('sounds/quack.mp3'));
    if (!_controller.isAnimating) {
      _controller.forward(from: 0).then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: GestureDetector(
        child: Image.asset(Assets.rubberDuck,
            width: widget.width, height: widget.height),
        onTap: () => _startShake(),
      ),
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: child,
        );
      },
    );
  }
}
