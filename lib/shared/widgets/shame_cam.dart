import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ShameCam extends StatefulWidget {
  final bool hideFlashButton;
  const ShameCam({super.key,  this.hideFlashButton = false});

  @override
  State<ShameCam> createState() => _ShameCamState();
}

class _ShameCamState extends State<ShameCam> {
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  int _currentCameraIndex = 0;
  bool _isFlashOn = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  // Inicializa todas as câmeras disponíveis e seleciona a primeira
  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        throw Exception('Nenhuma câmera disponível');
      }

      // Inicializa a primeira câmera (geralmente traseira)
      _initializeCameraController(_cameras[_currentCameraIndex]);
    } catch (e) {
      print('Erro ao inicializar as câmeras: $e');
      setState(() {
        _error = e.toString();
      });
    }
  }

  // Inicializa o controlador da câmera selecionada
  Future<void> _initializeCameraController(CameraDescription cameraDescription) async {
    _cameraController?.dispose();

    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _cameraController!.initialize();


      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print('Erro ao inicializar o controlador da câmera: $e');
      setState(() {
        _error = e.toString();
      });
    }
  }

  // Alterna entre as câmeras disponíveis
  void _switchCamera() {
    if (_cameras.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há outra câmera disponível')),
      );
      return;
    }

    setState(() {
      _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
      _isFlashOn = false; // Reseta o flash ao mudar a câmera
    });

    _initializeCameraController(_cameras[_currentCameraIndex]);
  }

  void _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
   

    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    try {
      await _cameraController!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    } catch (e) {
      print('Erro ao alternar o flash: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao alternar o flash: $e')),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
      
        borderRadius: BorderRadius.circular(12), 
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), 
        child: Stack(
          children: [
            _error != null
                ? Center(
                    child: Text(
                      'Erro: $_error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : (_cameraController != null && _cameraController!.value.isInitialized)
                    ? SizedBox(
                      width: 250,
                      height: 250,
                      child: CameraPreview(_cameraController!))
                    : const Center(child: CircularProgressIndicator()),
            if(widget.hideFlashButton)
            Positioned(
              bottom: 10,
              left: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _toggleFlash,
                  ),
                
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
