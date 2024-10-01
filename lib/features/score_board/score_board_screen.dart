import 'dart:ui';

import 'package:marcatruco/models/team.dart';
import 'package:marcatruco/shared/sheets/actions_sheet.dart';
import 'package:marcatruco/shared/widgets/score_widget.dart';
import 'package:marcatruco/shared/widgets/truco_button.dart';
import 'package:flutter/material.dart';
import 'package:marcatruco/features/score_board/score_board_controller.dart';

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
          name: 'us',
        ),
        teamB: Team(name: 'them'));
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
    bool? shouldReset = await showDialog<bool>(
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                title: const Text('Fim de Jogo!'),
                content: Text(
                    '$winningTeam atingiu ${ScoreBoardController.maxPoints} pontos. Deseja reiniciar a partida?'),
                actions: [
                  IconButton(onPressed: () => Navigator.of(context).pushNamed('/share_result', arguments: _scoreBoardController.match), icon: const Icon(Icons.share)),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Não'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Sim'),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;

    if (shouldReset) {
      _scoreBoardController.resetScores();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBuilder(
        animation: _scoreBoardController,
        builder: (context, child) => TrucoButton(
          initialMode: _scoreBoardController.riseMode,
          onRiseModeChanged: _scoreBoardController.updateRiseMode,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => showMatchActionsSheet(context, _scoreBoardController.match),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildLayout(),
      ),
    );
  }

  Widget _buildLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ScoreWidget(
                teamName: _scoreBoardController.match.teamA.name,
                score: _scoreBoardController.match.teamA.score,
                onAdd: _scoreBoardController.addPointTeamA,
                onSubtract: _scoreBoardController.subtractPointTeamA,
                riseMode: _scoreBoardController.riseMode,
                onNameChanged: (String name) {
                  _scoreBoardController.updateTeamName(
                      _scoreBoardController.match.teamA.id, name);
                },
              ),
            ),
            Expanded(
              child: ScoreWidget(
                teamName: _scoreBoardController.match.teamB.name,
                score: _scoreBoardController.match.teamB.score,
                riseMode: _scoreBoardController.riseMode,
                onAdd: _scoreBoardController.addPointTeamB,
                onSubtract: _scoreBoardController.subtractPointTeamB,
                onNameChanged: (String name) {
                  _scoreBoardController.updateTeamName(
                      _scoreBoardController.match.teamB.id, name);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
