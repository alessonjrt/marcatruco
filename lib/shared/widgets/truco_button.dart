import 'package:flutter/material.dart';
import 'package:marcatruco/shared/enums/rise_mode.dart';

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
      color: _getButtonColor(context),
      child: InkWell(
        onTap: _nextMode,
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_fire_department,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                _getButtonLabel(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
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
        return 'Tá valendo tudo!!';
      default:
        return 'Start Truco';
    }
  }

  String _getButtonLabel() {
    String nextAction = _getLabel(currentMode);
    return '$nextAction (${currentMode.value})';
  }

  Color _getButtonColor(BuildContext context) {
    switch (currentMode) {
      case RiseMode.none:
        return Theme.of(context).colorScheme.primary;
      case RiseMode.truco:
        return Colors.orange.shade200;
      case RiseMode.six:
        return Colors.red.shade300;
      case RiseMode.nine:
        return Colors.red.shade400;
      case RiseMode.twelve:
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
