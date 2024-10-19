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
  late Team winners;
  late Team losers;
  final WidgetsToImageController _widgetsToImageController =
      WidgetsToImageController();

  final bool _showShameCam = false;

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

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is Match) {
          setState(() {
            match = args;

            winners = match!.teamA.hasWon ? match!.teamA : match!.teamB;
            losers = !match!.teamA.hasWon ? match!.teamA : match!.teamB;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getRandomTeasingPhrase() {
    final random = Random();
    return teasingPhrases[random.nextInt(teasingPhrases.length)];
  }

  Future<void> _captureImage() async {
    setState(() {
      _isCapturing = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final imageBytes = await _widgetsToImageController.capture();

      if (imageBytes != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/captured_image.png';
        final imageFile = File(imagePath);

        await imageFile.writeAsBytes(imageBytes);

        final xfile = XFile(imagePath);

        await Share.shareXFiles(
          [xfile],
          text: 'Confira meu resultado no Truco!',
        );
      }
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const int pointDifferenceThreshold = 5;

    if (match == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    int pointDifference = winners.score - losers.score;

    bool showTeasing = pointDifference >= pointDifferenceThreshold;

    return WidgetsToImage(
      controller: _widgetsToImageController,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Visibility(
            visible: !_isCapturing,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.chevron_left_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: _showShameCam,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ShameCam(
                    hideFlashButton: !_isCapturing,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 60,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          winners.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                            shadows: const [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${winners.score} pontos',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Duck(
                          width: 80,
                          height: 60,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          losers.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                            shadows: const [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${losers.score} pontos',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (showTeasing)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    getRandomTeasingPhrase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              const SizedBox(height: 20),
              Visibility(
                visible: !_isCapturing,
                child: ElevatedButton.icon(
                  onPressed: _isCapturing ? null : _captureImage,
                  icon: Icon(
                    Icons.camera,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    'Capturar Imagem',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
