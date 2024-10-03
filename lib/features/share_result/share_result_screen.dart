import 'dart:io';
import 'package:flutter/material.dart';
import 'package:marcatruco/models/match.dart';
import 'package:marcatruco/models/team.dart';
import 'dart:math';
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

  // Variável para controlar a visibilidade do ShameCam
  bool _showShameCam = false;

  // Variável para controlar o estado de captura
  bool _isCapturing = false;

  final List<String> teasingPhrases = [
    "Que surra! Vai um óculos pra enxergar o jogo melhor?",
    "A sorte de vocês tá mais escassa que água no deserto!",
    "Estudem mais Truco, ou vão continuar apanhando assim!",
    "Foi bonito... se a intenção era fazer a gente rir!",
    "Na próxima, talvez vocês pelo menos assustem!",
    "Não fiquem tristes, perder é a especialidade de vocês!",
    "Vocês jogaram bem... bem mal, aliás!",
    "Truco? Mais pra Truco de mentirinha, né?!",
    "Cagaram no baralho e ainda fizeram pose!",
    "Se matasse empatava, mas nem isso conseguiram!"
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

  void _toggleShameCam() {
    setState(() {
      _showShameCam = !_showShameCam;
    });
  }

  Future<void> _captureImage() async {
    setState(() {
      _isCapturing = true;
    });

    try {
      // Pequena pausa para garantir que a UI seja atualizada
      await Future.delayed(const Duration(milliseconds: 100));

      final imageBytes = await _widgetsToImageController.capture();

      if (imageBytes != null) {
        // Obter o diretório para salvar a imagem
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/captured_image.png';
        final imageFile = File(imagePath);

        // Escrever os bytes da imagem no arquivo
        await imageFile.writeAsBytes(imageBytes);

        // Criar um XFile a partir do arquivo salvo
        final xfile = XFile(imagePath);

        // Compartilhar a imagem usando share_plus
        await Share.shareXFiles(
          [xfile],
          text: 'Confira meu resultado no Truco!',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagem capturada e compartilhada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao capturar a imagem.')),
        );
      }
    } catch (e) {
      // Tratar erros de captura
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
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
              icon: const Icon(Icons.chevron_left_rounded),
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
        ),
        body:  SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: _showShameCam,
                    child:  Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ShameCam(hideFlashButton: !_isCapturing,),
                    ),
                  ),
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
                            const Duck(
                              width: 80,
                            ),
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
                  const SizedBox(height: 20),
                  Visibility(
                    visible: !_isCapturing,
                    child: ElevatedButton.icon(
                      onPressed: _isCapturing ? null : _captureImage,
                      icon: const Icon(Icons.camera),
                      label: const Text('Capturar Imagem'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        floatingActionButton: !_isCapturing
            ? FloatingActionButton.extended(
                onPressed: _toggleShameCam,
                label: Text(_showShameCam
                    ? 'Ocultar ShameCam'
                    : 'Adicionar ShameCam'),
                icon:
                    Icon(_showShameCam ? Icons.close : Icons.camera_alt),
              )
            : null, // O botão não será exibido durante a captura
      ),
    );
  }
}
