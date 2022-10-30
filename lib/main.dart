import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recyclescan/box.dart';
//import 'package:json_annotation/json_annotation.dart';

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
    _controller = CameraController(widget.camera, ResolutionPreset.low,
        enableAudio: false);
    res = Tflite.loadModel(
        model: "assets/yolov2_tiny.tflite",
        labels: "assets/yolov2_tiny.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);
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
            return CameraPreview(
              _controller,
              child: BoxContainer(camera: _controller),
            );
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

class BoxContainer extends StatefulWidget {
  final CameraController camera;

  const BoxContainer({super.key, required this.camera});

  @override
  State<StatefulWidget> createState() => _BoxContainerState();
}

class _BoxContainerState extends State<BoxContainer> {
  bool busy = false;
  var recognitions = [];
  CameraImage? image;

  @override
  void initState() {
    super.initState();
    widget.camera.startImageStream((CameraImage image) async {
      if (busy) return;
      busy = true;
      var recog = await Tflite.detectObjectOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        model: "YOLO",
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 0,
        imageStd: 255.0,
        threshold: 0.1,
        numResultsPerClass: 2,
        anchors: Tflite.anchors,
        blockSize: 32,
        numBoxesPerBlock: 5,
        asynch: true
      );
      if (recog != null) {
        setState(() {
          recognitions = recog;
          print(recog);
          this.image = image;
          busy = false;
        });
      }
    });
  }

  _mapCallBack(e) {
    var t = json.decode(json.encode(e));
    var rect = t["rect"];
    var h = rect["h"];
    var w = rect["w"];
    var x = rect["x"];
    var y = rect["y"];
    var px = image!.height * x;
    var py = image!.height * y;
    var height = image!.height * h;
    var width = image!.width * w;
    return BoxWithBorder(
        height: height as double, width: width as double, posX: px as double, posY: py as double );
  }

  @override
  Widget build(BuildContext context) {
    //var widgets = recognitions.map(_mapCallBack).toList();
    var widgets = null;
    if (!recognitions.isEmpty) {
      widgets = recognitions.map((e) => _mapCallBack(e) as BoxWithBorder).toList();
      //widgets = [_mapCallBack(recognitions[0])].map((e) => e as BoxWithBorder).toList();
    }
    return Stack(
      children: widgets == null ? [] : widgets,
    );
  }
}

class DetectedObject {
  late Rect rect;
  late double confidenceInClass;
  late String detectedClass;
}

class Rect {
  late double w;
  late double h;
  late double y;
  late double x;
}
