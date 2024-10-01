import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:marcatruco/models/match.dart';
import 'package:marcatruco/models/team.dart';
import 'dart:math';

import 'package:marcatruco/shared/assets/assets.dart';
import 'package:marcatruco/shared/widgets/duck.dart';

class ShareResultScreen extends StatefulWidget {
  const ShareResultScreen({Key? key}) : super(key: key);

  @override
  State<ShareResultScreen> createState() => _ShareResultScreenState();
}

class _ShareResultScreenState extends State<ShareResultScreen> {
  CameraController? _cameraController;
  Match? match;
  late Team winners;
  late Team losers;
  Future<void>? _initializeControllerFuture;

  final List<String> teasingPhrases = [
    "Que foi, perdem tudo?",
    "Vocês tão precisando de sorte!",
    "Melhor estudar mais Truco!",
    "Foi bonito, mas não foi dessa vez!",
    "Na próxima, hein?",
    "Não fiquem tristes, a sorte muda!",
    "Vocês jogaram, mas a sorte não colaborou!",
    "Truco? Mais como Três-Cu!",
    "Tá difícil? Vamos rir disso!",
    "Vocês chamaram de Truco ou de azar?"
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('Nenhuma câmera disponível');
      }

      CameraDescription selectedCamera;
      try {
        selectedCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
        );
      } catch (e) {
        selectedCamera = cameras.first;
      }

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializeControllerFuture = _cameraController!.initialize();

      await _initializeControllerFuture;

      if (!mounted) return;

      setState(() {});
    } catch (e) {
      print('Erro ao inicializar a câmera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao inicializar a câmera: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  String getRandomTeasingPhrase() {
    final random = Random();
    return teasingPhrases[random.nextInt(teasingPhrases.length)];
  }

  @override
  Widget build(BuildContext context) {
    const int pointDifferenceThreshold = 5;

    int pointDifference = (winners.score) - (losers.score);

    bool showTeasing = pointDifference >= pointDifferenceThreshold;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
      ),
      body: match != null
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
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
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                                shadows: [
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
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Duck(width: 80,),
                            const SizedBox(height: 10),
                            Text(
                              losers.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                                shadows: [
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
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white70,
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
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
