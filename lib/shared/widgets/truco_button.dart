import 'package:marcatruco/shared/enums/rise_mode.dart';
import 'package:flutter/material.dart';

class TrucoButton extends StatelessWidget {
  final RiseMode currentMode;
  final ValueChanged<RiseMode> onRiseModeChanged;

  const TrucoButton({
    super.key,
    required this.onRiseModeChanged,
    required this.currentMode,
  });

 
  void _nextMode() {
   onRiseModeChanged(currentMode.next);
  }

 
  @override
  Widget build(BuildContext context) {
    return Material(
      color: _getButtonColor(),
      child: InkWell(
        onTap: _nextMode,
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
              const SizedBox(width: 8), 
              Text(
                _getButtonLabel(),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }

   String _getLabel(RiseMode mode) {
    switch (mode) {
      case RiseMode.none:
        return 'Truco!';
      case RiseMode.truco:
        return 'Seis!';
      case RiseMode.six:
        return 'Nove!';
      case RiseMode.nine:
        return 'Doze!';
      case RiseMode.twelve:
        return 'Ta valendo tudo!!';
      default:
        return 'Start Truco';
    }
  }

  String _getButtonLabel() {
    String nextAction = _getLabel(currentMode);
    return '$nextAction (${currentMode.value})';
  }

  Color _getButtonColor() {
    switch (currentMode) {
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

}
