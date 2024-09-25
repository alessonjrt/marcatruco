import 'package:cardmate/shared/widgets/score_widget.dart';
import 'package:cardmate/shared/widgets/truco_button.dart';
import 'package:flutter/material.dart';
import 'package:cardmate/features/score_board/score_board_controller.dart';

class ScoreBoardPage extends StatefulWidget {
  const ScoreBoardPage({super.key});

  @override
  State<ScoreBoardPage> createState() => _ScoreBoardPageState();
}

class _ScoreBoardPageState extends State<ScoreBoardPage> {
  late ScoreBoardController _scoreBoardController;

  @override
  void initState() {
    _scoreBoardController = ScoreBoardController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.grid_on),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: _buildLayout(),
      ),
    );
  }

  Widget _buildLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _scoreBoardController,
                builder: (context, child) => ScoreWidget(
                  teamName: "Equipe 1",
                  score: _scoreBoardController.team1Score,
                  onAdd: _scoreBoardController.addPointTeam1,
                  onSubtract: _scoreBoardController.subtractPointTeam1,
                ),
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _scoreBoardController,
                builder: (BuildContext context, Widget? child) {
                  return ScoreWidget(
                    teamName: "Equipe 2",
                    score: _scoreBoardController.team2Score,
                    onAdd: _scoreBoardController.addPointTeam2,
                    onSubtract: _scoreBoardController.subtractPointTeam2,
                  );
                },
              ),
            ),
          ],
        ),
        TrucoButton(onRiseModeChanged: (value) => {},)
   
      ],
    );
  }

  @override
  void dispose() {
    _scoreBoardController.dispose();
    super.dispose();
  }
}
