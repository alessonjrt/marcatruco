import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ShameCam extends StatefulWidget {
  final bool hideFlashButton;
  const ShameCam({super.key, this.hideFlashButton = false});

  @override
  State<ShameCam> createState() => _ShameCamState();
}

class _ShameCamState extends State<ShameCam> {
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  final int _currentCameraIndex = 0;
  bool _isFlashOn = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        throw Exception('Nenhuma câmera disponível');
      }

      _initializeCameraController(_cameras[_currentCameraIndex]);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
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
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    await _cameraController!
        .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
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
                : (_cameraController != null &&
                        _cameraController!.value.isInitialized)
                    ? SizedBox(
                        width: 250,
                        height: 250,
                        child: CameraPreview(_cameraController!))
                    : const Center(child: CircularProgressIndicator()),
            if (widget.hideFlashButton)
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
