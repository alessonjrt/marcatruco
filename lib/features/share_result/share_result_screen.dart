import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marcatruco/models/match.dart';
import 'package:marcatruco/models/team.dart';
import 'package:marcatruco/shared/widgets/duck.dart';
import 'package:marcatruco/shared/widgets/shame_cam.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ShareResultScreen extends StatefulWidget {
  const ShareResultScreen({super.key});

  @override
  State<ShareResultScreen> createState() => _ShareResultScreenState();
}

class _ShareResultScreenState extends State<ShareResultScreen> {
  Match? match;
  final WidgetsToImageController _widgetsToImageController =
      WidgetsToImageController();

  bool _isCapturing = false;

  final List<String> teasingPhrases = [
    "Essa era café com leite.",
    "A sorte de vocês tá mais escassa que água no deserto!",
    "Estudem mais Truco, ou vão continuar apanhando assim!",
    "Foi bonito... se a intenção era fazer a gente rir!",
    "Na próxima, talvez vocês pelo menos assustem!",
    "Não fiquem tristes, perder é a especialidade de vocês!",
    "Na cara não, pra não estragar o velório.",
    "Que sapeco!",
    "C*garam na mão e jogaram na cara...",
    "Se matasse, empatava!"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_initializeMatchData);
  }

  void _initializeMatchData(Duration _) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Match) {
      setState(() {
        match = args;
      });
    }
  }

  String getRandomTeasingPhrase() {
    return teasingPhrases[Random().nextInt(teasingPhrases.length)];
  }

  Future<void> _captureImage() async {
    setState(() => _isCapturing = true);

    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final imageBytes = await _widgetsToImageController.capture();

      if (imageBytes != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/captured_image.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);

        await Share.shareXFiles(
          [XFile(imagePath)],
          text: 'Confira meu resultado no Truco!',
        );
      }
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: match == null
          ? const Center(child: CircularProgressIndicator())
          : _buildResultContent(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      leading: Visibility(
        visible: !_isCapturing,
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.chevron_left_rounded,
            size: 42,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      actions: [
        Visibility(
          visible: !_isCapturing,
          child: IconButton(
            onPressed: _isCapturing ? null : _captureImage,
            icon: Icon(
              Icons.share,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultContent() {
    final Team teamA = match!.teamA;
    final Team teamB = match!.teamB;
    final int pointDifference = (teamA.hasWon ? teamA.score : teamB.score) -
        (teamA.hasWon ? teamB.score : teamA.score);
    final bool showTeasing = pointDifference >= 5;

    return WidgetsToImage(
      controller: _widgetsToImageController,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildShameCam(),
            const SizedBox(height: 30),
            _buildScoreRow(teamA, teamB),
            const SizedBox(height: 30),
            if (showTeasing) _buildTeasingPhrase(),
          ],
        ),
      ),
    );
  }

  Widget _buildShameCam() {
    return Visibility(
      visible: false, // Configurável se desejar habilitar.
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: ShameCam(
          hideFlashButton: !_isCapturing,
        ),
      ),
    );
  }

  Widget _buildScoreRow(Team teamA, Team teamB) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTeamWidget(teamA),
        _buildTeamWidget(teamB),
      ],
    );
  }

  Widget _buildTeamWidget(Team team) {
    final bool isWinner = team.hasWon;
    return Expanded(
      child: Column(
        children: [
          isWinner
              ? const Icon(Icons.emoji_events, color: Colors.amber, size: 60)
              : const Duck(width: 80, height: 60),
          const SizedBox(height: 10),
          Text(
            team.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isWinner
                      ? Colors.amber
                      : Theme.of(context).colorScheme.error,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            '${team.score} pontos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeasingPhrase() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        getRandomTeasingPhrase(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }
}
