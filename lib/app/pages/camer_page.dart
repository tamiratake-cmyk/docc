import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CamerPage extends StatefulWidget {
  const CamerPage({super.key});

  @override
  State<CamerPage> createState() => _CamerPageState();
}

class _CamerPageState extends State<CamerPage> {
  CameraController? _controller;


  @override
  void initState() {
    super.initState();
     initCamera();
  }

Future<void> initCamera() async {
  await Permission.camera.request();

  final camers = await availableCameras();
  _controller = CameraController(
    camers.first,
    ResolutionPreset.high,
  );
  await _controller?.initialize();
  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : CameraPreview(_controller!),
    );
  }
  

}
