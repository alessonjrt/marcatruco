import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marcatruco/features/score_board/score_board_controller.dart';
import 'package:marcatruco/models/team.dart';
import 'package:marcatruco/shared/sheets/actions_sheet.dart';
import 'package:marcatruco/shared/widgets/score_widget.dart';
import 'package:marcatruco/shared/widgets/truco_button.dart';

class ScoreBoardScreen extends StatefulWidget {
  const ScoreBoardScreen({super.key});

  @override
  State<ScoreBoardScreen> createState() => _ScoreBoardScreenState();
}

class _ScoreBoardScreenState extends State<ScoreBoardScreen> {
  late ScoreBoardController _scoreBoardController;

  @override
  void initState() {
    super.initState();
    _scoreBoardController = ScoreBoardController(
        teamA: Team(
          name: 'Nós',
        ),
        teamB: Team(name: 'Eles'));
    _scoreBoardController.addListener(_controllerListener);
  }

  @override
  void dispose() {
    _scoreBoardController.removeListener(_controllerListener);
    _scoreBoardController.dispose();
    super.dispose();
  }

  void _controllerListener() {
    if (_scoreBoardController.isGameOver) {
      _showEndGameDialog();
    }
    setState(() {});
  }

  Future<void> _showEndGameDialog() async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        String winningTeam = _scoreBoardController.match.teamA.hasWon
            ? _scoreBoardController.match.teamA.name
            : _scoreBoardController.match.teamB.name;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            title: Text(
              'Fim de Jogo!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
              '$winningTeam atingiu ${ScoreBoardController.maxPoints} pontos. Deseja compartilar o resultado?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed(
                    '/share_result',
                    arguments: _scoreBoardController.match),
                icon: Icon(
                  Icons.share,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Não'))
            ],
          ),
        );
      },
    );

    _scoreBoardController.resetScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBuilder(
        animation: _scoreBoardController,
        builder: (context, child) => TrucoButton(
          currentMode: _scoreBoardController.match.riseMode,
          onRiseModeChanged: _scoreBoardController.updateRiseMode,
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        surfaceTintColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.history,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () =>
                showMatchActionsSheet(context, _scoreBoardController.match),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ScoreWidget(
                  team: _scoreBoardController.match.teamA,
                  onAdd: _scoreBoardController.addPointTeamA,
                  onSubtract: _scoreBoardController.subtractPointTeamA,
                  riseMode: _scoreBoardController.match.riseMode,
                  onFold: () {
                    _scoreBoardController.fold(
                        _scoreBoardController.match.teamA,
                        _scoreBoardController.match.teamB);
                  },
                  onNameChanged: (String name) {
                    _scoreBoardController.updateTeamName(
                        _scoreBoardController.match.teamA.id, name);
                  },
                ),
              ),
              Expanded(
                child: ScoreWidget(
                  team: _scoreBoardController.match.teamB,
                  riseMode: _scoreBoardController.match.riseMode,
                  onAdd: _scoreBoardController.addPointTeamB,
                  onSubtract: _scoreBoardController.subtractPointTeamB,
                  onNameChanged: (String name) {
                    _scoreBoardController.updateTeamName(
                        _scoreBoardController.match.teamB.id, name);
                  },
                  onFold: () {
                    _scoreBoardController.fold(
                        _scoreBoardController.match.teamB,
                        _scoreBoardController.match.teamA);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
