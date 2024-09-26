import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ShareResultScreen extends StatefulWidget {
  const ShareResultScreen({super.key});

  @override
  State<ShareResultScreen> createState() => _ShareResultScreenState();
}

class _ShareResultScreenState extends State<ShareResultScreen> {
  File? _imageFile;

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tirar Foto com Moldura'),
      ),
      body: Center(
        child: _imageFile == null
            ? ElevatedButton(
                onPressed: _takePhoto,
                child: const Text('Tirar Foto'),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 10),
                ),
                child: Image.file(_imageFile!),
              ),
      ),
    );
  }
}
