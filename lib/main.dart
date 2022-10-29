import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as imglib;
import 'package:permission_handler/permission_handler.dart';
import 'package:recyclescan/box.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.storage.request();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: TakePictureScreen(camera: firstCamera),
  ));


}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late Future<String?> res;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.low,
      enableAudio: false
    );
    res = Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() async {
    // Dispose of the controller when the widget is disposed.
    await _controller.dispose();
    await Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            _controller.startImageStream((CameraImage image) async {
              if (busy) return;
              busy = true;
              var recognitions = await Tflite.detectObjectOnFrame(
                bytesList: image.planes.map((plane) {return plane.bytes;}).toList(),
                numResultsPerClass: 1,
                imageHeight: image.height,
                imageWidth: image.width,
              );
              print(recognitions);
              busy = false;
            });
            return CameraPreview( _controller, child: BoxWithBorder(height: 150.0, width: 150.0, posX: 0.0, posY: 0.0,),);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          print("click");
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}