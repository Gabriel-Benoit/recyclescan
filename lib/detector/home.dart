import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import 'detector.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({super.key, required this.camera});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final CameraController _controller;
  late final Future<void> _initialized;
  late final bool busy = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.low,
        enableAudio: false);
    Future<String?> model = Tflite.loadModel(
        model: "assets/yolov2_tiny.tflite",
        labels: "assets/yolov2_tiny.txt",
        numThreads: 4,
        isAsset: true,
        useGpuDelegate: false);
    _initialized = Future.wait([_controller.initialize(), model]);
  }

  @override
  void dispose() async {
    super.dispose();
    await Future.wait([_controller.dispose(), Tflite.close()]);
  }

// Ajouter une var de state qui est la vue à afficher
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialized,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            color: Colors.green,
            child: Column(
              children: [
                Expanded(
                  child: ObjectDetector(controller: _controller),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
