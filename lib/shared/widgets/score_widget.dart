import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:marcatruco/models/team.dart';
import 'package:marcatruco/shared/enums/rise_mode.dart';

class ScoreWidget extends StatefulWidget {
  final Team team;
  final void Function(int value) onAdd;
  final VoidCallback onSubtract;
  final VoidCallback onFold;
  final void Function(String)? onNameChanged;
  final RiseMode riseMode;

  const ScoreWidget({
    super.key,
    required this.onAdd,
    required this.onSubtract,
    this.onNameChanged,
    required this.riseMode,
    required this.onFold,
    required this.team,
  });

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  final bool _isInverted = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: InkWell(
        child: Transform(
          alignment: Alignment.center,
          transform:
              _isInverted ? Matrix4.rotationX(3.14159) : Matrix4.identity(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildTeamNameInput(context),
              Badge(
                backgroundColor: Colors.transparent,
                alignment: Alignment.centerRight,
                isLabelVisible:
                    widget.team.score >= 10 && widget.team.score != 12,
                offset: const Offset(-18, 25),
                label: Lottie.asset(
                  width: 30,
                  'assets/animations/fire.json',
                ),
                child: Text(
                  widget.team.score.toString(),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: 110),
                ),
              ),
              _buildScoreControls(context),
              Visibility(
                visible: widget.riseMode != RiseMode.none,
                child: _buildFoldButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamNameInput(BuildContext context) {
    return TextFormField(
      onChanged: widget.onNameChanged,
      initialValue: widget.team.name,
      textAlign: TextAlign.center,
      maxLines: null, // Permitir várias linhas.
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      style: Theme.of(context).textTheme.headlineMedium,
      textAlignVertical: TextAlignVertical.center,
    );
  }

  Widget _buildScoreControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.remove,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: widget.onSubtract,
        ),
        IconButton(
          color: Theme.of(context).colorScheme.error,
          icon: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                '${widget.riseMode.value}',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          onPressed: () => widget.onAdd(widget.riseMode.value),
        ),
      ],
    );
  }

  Widget _buildFoldButton(BuildContext context) {
    return TextButton.icon(
      onPressed: widget.onFold,
      icon: Text(
        'Correr',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      label: Icon(
        Icons.directions_run,
        color: Theme.of(context).colorScheme.primary,
      ),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
