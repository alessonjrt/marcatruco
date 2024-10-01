// lib/screens/share_result_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class ShareResultScreen extends StatefulWidget {
  const ShareResultScreen({Key? key}) : super(key: key);

  @override
  State<ShareResultScreen> createState() => _ShareResultScreenState();
}

class _ShareResultScreenState extends State<ShareResultScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inicializa a câmera disponível
  Future<void> _initializeCamera() async {
    try {
      // Obtém a lista de câmeras disponíveis no dispositivo
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        // Se não houver câmeras disponíveis, exibe uma mensagem de erro
        throw Exception('Nenhuma câmera disponível');
      }

      // Tenta selecionar a câmera traseira; se não encontrar, usa a primeira câmera disponível
      CameraDescription selectedCamera;
      try {
        selectedCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
        );
      } catch (e) {
        // Se nenhuma câmera traseira for encontrada, usa a primeira câmera disponível
        selectedCamera = cameras.first;
      }

      // Cria o controlador da câmera
      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      // Inicializa o controlador da câmera
      _initializeControllerFuture = _cameraController!.initialize();

      await _initializeControllerFuture;

      if (!mounted) return;

      setState(() {});
    } catch (e) {
      print('Erro ao inicializar a câmera: $e');
      // Exibe uma mensagem de erro para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao inicializar a câmera: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    // Desativa o controlador da câmera quando o widget é destruído
    _cameraController?.dispose();
    super.dispose();
  }

  // Função para capturar a foto
  Future<void> _takePhoto() async {
    try {
      if (_cameraController == null || !_cameraController!.value.isInitialized) {
        throw Exception('Controlador da câmera não está inicializado');
      }

      // Captura a imagem e obtém o caminho do arquivo
      final image = await _cameraController!.takePicture();

      // Define o diretório para salvar a imagem
      final directory = await getApplicationDocumentsDirectory();
      final String path = join(directory.path, '${DateTime.now()}.png');

      // Copia a imagem para o diretório
      await image.saveTo(path);

      // Armazena a imagem capturada
      setState(() {
        _capturedImage = XFile(path);
      });
    } catch (e) {
      print('Erro ao capturar a foto: $e');
      // Exibe uma mensagem de erro para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao capturar a foto.')),
      );
    }
  }

  // Função para retomar a câmera após capturar uma foto
  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se o controlador da câmera não estiver inicializado, exibe uma mensagem de erro
    if (_cameraController == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tirar Foto com Moldura'),
        ),
        body: const Center(
          child: Text('Nenhuma câmera disponível.'),
        ),
      );
    }

    // Verifica se o controlador da câmera está inicializado
    if (!_cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tirar Foto com Moldura'),
      ),
      body: Stack(
        children: [
          // Pré-visualização da câmera
          CameraPreview(_cameraController!),

          // Moldura quadrada sobre a pré-visualização
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250, // Largura do quadrado
              height: 250, // Altura do quadrado
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 4,
                ),
              ),
            ),
          ),

          // Exibição da imagem capturada
          if (_capturedImage != null)
            Container(
              color: Colors.black54,
              child: Center(
                child: Image.file(
                  File(_capturedImage!.path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _capturedImage == null
          ? FloatingActionButton(
              onPressed: _takePhoto,
              child: const Icon(Icons.camera_alt),
              tooltip: 'Capturar Foto',
            )
          : FloatingActionButton(
              onPressed: _retakePhoto,
              child: const Icon(Icons.refresh),
              tooltip: 'Tirar Outra Foto',
              backgroundColor: Colors.red,
            ),
    );
  }
}
