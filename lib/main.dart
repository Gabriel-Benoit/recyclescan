import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:recyclescan/garbage.dart';
import 'package:recyclescan/rule.dart';
import 'package:tflite/tflite.dart';
import 'package:recyclescan/box.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final camera = cameras.first;

  runApp(MaterialApp(
    title: 'RecycleScan',
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    home: HomePage(camera: camera),
  ));
}

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
    _controller = CameraController(widget.camera, ResolutionPreset.low, enableAudio: false);
    Future<String?> model = Tflite.loadModel(
      model: "assets/yolov2_tiny.tflite",
      labels: "assets/yolov2_tiny.txt",
      numThreads: 4,
      isAsset: true,
      useGpuDelegate: false
    );
    _initialized = Future.wait([_controller.initialize(), model]);
  }

  @override
  void dispose() async {
    super.dispose();
    await Future.wait([_controller.dispose(), Tflite.close()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RecycleScan')),
      body: FutureBuilder<void>(
        future: _initialized,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ObjectDetector(controller: _controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}

class ObjectDetector extends StatefulWidget {

  final CameraController controller;

  const ObjectDetector({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() => _ObjectDetectorState();
}

class _ObjectDetectorState extends State<ObjectDetector> {

  late List<dynamic> recognitions = [];
  late CameraImage image;
  bool busy = false;
  Garbage? garbage;
  bool isDetectionStarted = false;
  late Widget preview;

  @override
  void initState() {
    super.initState();
    _beginDetection();
    preview = AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: CameraPreview(widget.controller),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pauseDetection();
  }

  Future<void> _beginDetection() async {
    if (isDetectionStarted) return;
    isDetectionStarted = true;

    await widget.controller.startImageStream((image) async {
      if (busy) return;
      busy = true;
      List<dynamic>? recognitions = await Tflite.detectObjectOnFrame(
        bytesList: image.planes.map((plane) => plane.bytes).toList(),
        model: "YOLO",
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 0,
        imageStd: 255.0,
        threshold: 0.5,
        numResultsPerClass: 2,
        anchors: Tflite.anchors,
        blockSize: 32,
        numBoxesPerBlock: 5,
        asynch: true
      );
      busy = false;
      setState(() {
        this.recognitions = recognitions ?? [];
        this.image = image;
      });
    });
  }

  Future<void> _pauseDetection() async {
    if (!isDetectionStarted) return;
    isDetectionStarted = false;

    await widget.controller.stopImageStream();
  }

  void _setGarbage(Garbage? garbage) {
    setState(() {
      this.garbage = garbage;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> widgets = [];

    widgets.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height,
        child: SizedBox(
          height: size.height,
          child: preview
        ),
      ),
    );

    widgets.addAll(
      recognitions.map((result) =>
        Box(
          posX: result["rect"]["x"] * size.width,
          posY: result["rect"]["y"] * size.height,
          width: result["rect"]["w"] * size.width,
          height: result["rect"]["h"] * size.height,
          color: Colors.green,
          onPressed: () {
            _setGarbage(Garbage(name: result["detectedClass"], imageUrl: ""));
            _pauseDetection();
          },
        )
      )
    );

    if (garbage != null) {
      widgets.add(
        WasteDescription(
          garbage: garbage!,
          rule: const Rule(color: Colors.blue, imageUrl: "", name: "test"),
          closeCallBack: () {
            _setGarbage(null);
            _beginDetection();
          }
        )
      );
    }

    return Stack(
      children: widgets,
    );
  }
}

class WasteDescription extends StatelessWidget {

  final Garbage garbage;
  final Rule rule;
  final void Function() closeCallBack;

  const WasteDescription({super.key, required this.garbage, required this.rule, required this.closeCallBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Text("${garbage.name} ${rule.name}"),
          Positioned(
            child: CloseButton(
              onPressed: closeCallBack,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }
}