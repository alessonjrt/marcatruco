import 'package:cardmate/shared/enums/rise_mode.dart';
import 'package:flutter/material.dart';

class TrucoButton extends StatefulWidget {
  final ValueChanged<RiseMode> onRiseModeChanged;

  const TrucoButton({Key? key, required this.onRiseModeChanged}) : super(key: key);

  @override
  State<TrucoButton> createState() => _TrucoButtonState();
}

class _TrucoButtonState extends State<TrucoButton> {
  RiseMode _currentMode = RiseMode.none;

  void _nextMode() {
    setState(() {
      switch (_currentMode) {
        case RiseMode.none:
          _currentMode = RiseMode.truco;
          break;
        case RiseMode.truco:
          _currentMode = RiseMode.six;
          break;
        case RiseMode.six:
          _currentMode = RiseMode.nine;
          break;
        case RiseMode.nine:
          _currentMode = RiseMode.twelve;
          break;
        case RiseMode.twelve:
          _currentMode = RiseMode.none; 
          break;
      }
      widget.onRiseModeChanged(_currentMode);
    });
  }

  String _getButtonLabel() {
    switch (_currentMode) {
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
    switch (_currentMode) {
      case RiseMode.none:
        return Colors.black;
      case RiseMode.truco:
        return Colors.red;
      case RiseMode.six:
        return Colors.orange;
      case RiseMode.nine:
        return Colors.blue;
      case RiseMode.twelve:
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: Text(
        _getButtonLabel(),
        style: TextStyle(color: _getButtonColor()),
      ),
      onPressed: _nextMode,
      icon: Icon(
        Icons.local_fire_department,
        color: _getButtonColor(),
      ),
    );
  }
}