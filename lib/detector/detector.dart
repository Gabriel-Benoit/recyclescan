import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:recyclescan/detector/wastedescription.dart';
import 'package:recyclescan/main.dart';
import 'package:tflite/tflite.dart';

import '../garbage.dart';
import '../rule.dart';
import 'box.dart';

GlobalKey _camPreviewSize = GlobalKey(debugLabel: "cam_size");

Size? _getCamSize() {
  final RenderObject? renderBox =
      _camPreviewSize.currentContext?.findRenderObject();
  if (renderBox == null) {
    return null;
  }
  return (renderBox as RenderBox).size;
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
  late Container preview;

  @override
  void initState() {
    super.initState();
    _beginDetection();

    preview = Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
          )
        ],
      ),
      child: CameraPreview(key: _camPreviewSize, widget.controller),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _pauseDetection();
    await widget.controller.dispose();
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
          asynch: true);
      busy = false;
      if (!isDetectionStarted) return;
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
    if (garbage == null) {
      title.currentState!.defaultText();
    } else {
      title.currentState!.setText(garbage.name);
    }
    if (!isDetectionStarted) return;
    setState(() {
      this.garbage = garbage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (garbage != null) {
      return Stack(
        children: [
          WasteDescription(
            garbage: garbage!,
            changeGarbageCallBack: (g) async {
              await _beginDetection();
              _setGarbage(g);
              await _pauseDetection();
            },
            rule: const Rule(
                color: Color.fromARGB(255, 101, 166, 219),
                image: NetworkImage(
                    "https://upload.wikimedia.org/wikipedia/commons/6/6c/Tolkki20091027.jpg"),
                name: "test"),
            closeCallBack: () async {
              await _beginDetection();
              _setGarbage(null);
            },
          )
        ],
      );
    }

    Size? size = _getCamSize();
    size ??= const Size(0.0, 0.0);
    List<Widget> widgets = [];

    widgets.add(preview);

    widgets.addAll(
      recognitions.map(
        (result) => Box(
          posX: result["rect"]["x"] * size!.width,
          posY: result["rect"]["y"] * size.height,
          width: result["rect"]["w"] * size.width,
          height: result["rect"]["h"] * size.height,
          color: Colors.green,
          onPressed: () {
            _setGarbage(garbages["bottle"]!
                //Garbage(
                //  name: result["detectedClass"],
                //  image: const NetworkImage(
                //      "https://upload.wikimedia.org/wikipedia/commons/6/6c/Tolkki20091027.jpg"),
                //),
                );
            _pauseDetection();
          },
        ),
      ),
    );

    return Stack(
      children: widgets,
    );
  }
}
