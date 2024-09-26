import 'package:cardmate/shared/enums/rise_mode.dart';
import 'package:flutter/material.dart';

class TrucoButton extends StatefulWidget {
  final RiseMode initialMode;
  final ValueChanged<RiseMode> onRiseModeChanged;

  const TrucoButton(
      {super.key, required this.onRiseModeChanged, required this.initialMode});

  @override
  State<TrucoButton> createState() => _TrucoButtonState();
}

class _TrucoButtonState extends State<TrucoButton> {
  @override
  void initState() {
    super.initState();
  }

  void _nextMode() {
    widget.onRiseModeChanged(widget.initialMode.next);
  }



  String _getButtonLabel() {
    switch (widget.initialMode) {
      case RiseMode.none:
        return 'truco!';
      case RiseMode.truco:
        return 'seis!';
      case RiseMode.six:
        return 'nove!';
      case RiseMode.nine:
        return 'doze!';
      case RiseMode.twelve:
        return 'ta valendo 12!';
      default:
        return 'Start Truco';
    }
  }

  Color _getButtonColor() {
    switch (widget.initialMode) {
      case RiseMode.none:
        return Colors.redAccent;
      case RiseMode.truco:
        return Colors.red;
      case RiseMode.six:
        return Colors.orange;
      case RiseMode.nine:
        return Colors.blue;
      case RiseMode.twelve:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _getButtonColor(),
      child: InkWell(
        onTap: () => _nextMode(),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.white,
              ),
              Text(
                _getButtonLabel(),
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
