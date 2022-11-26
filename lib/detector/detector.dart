import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:recyclescan/detector/wastedescription.dart';
import 'package:recyclescan/main.dart';
import 'package:tflite/tflite.dart';

import '../garbage.dart';
import '../rule.dart';
import 'box.dart';

/// Clé globale permettant de briser la hiérarchie dans l'abre.
/// Cette clé est utilisée pour obtenir la taille effective de
/// la caméra après le rendu
GlobalKey _camPreviewSize = GlobalKey(debugLabel: "cam_size");

/// Permet de récuperer les dimensions de la caméra en
/// utilisant la clé globale ```_camPreviewSize```. Si
/// le rendu de la caméra n'est pas encore fait alors null
/// est retourné
Size? _getCamSize() {
  final RenderObject? renderBox =
      _camPreviewSize.currentContext?.findRenderObject();
  if (renderBox == null) {
    return null;
  }
  return (renderBox as RenderBox).size;
}

/// Classe intéragissant avec le modèle de reconnaissance d'objets en temps réel
class ObjectDetector extends StatefulWidget {
  final CameraController controller;
  late Map<Garbage, Rule> currentRules;

  ObjectDetector({super.key, required this.controller});

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
    widget.currentRules = rules[prefs!.get("location")]!;
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

  /// Démarre la reconnaissance d'objets en temps réel
  Future<void> _beginDetection() async {
    if (isDetectionStarted) return;
    isDetectionStarted = true;

    await widget.controller.startImageStream((image) async {
      if (busy) return;
      busy = true;
      // On récupère les objets identifiés
      List<dynamic>? recognitions = await Tflite.detectObjectOnFrame(
          bytesList: image.planes.map((plane) => plane.bytes).toList(),
          model: "YOLO",
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 0,
          imageStd: 255.0,
          threshold: 0.4,
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

  /// Met en pause la reconnaissance d'objets en temps réel
  Future<void> _pauseDetection() async {
    if (!isDetectionStarted) return;
    isDetectionStarted = false;

    await widget.controller.stopImageStream();
  }

  /// Permet de d'assigner un déchet selectionné.
  /// On peut distinguer 2 cas:
  /// - si ```garbage == null``` alors on relancera la détection
  /// - sinon on affiche la description du déchet passé
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
    // Si on a sélectionné un déchet, on affiche la description de celui-ci
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
            rule: widget.currentRules[garbage!]!,
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

    // Ajout de la prévisualisation de la caméra
    widgets.add(preview);

    // Ajout des détections
    widgets.addAll(
      recognitions.map(
        (result) => Box(
          posX: result["rect"]["x"] * size!.width,
          posY: result["rect"]["y"] * size.height,
          width: result["rect"]["w"] * size.width,
          height: result["rect"]["h"] * size.height,
          color: widget.currentRules[garbages[result["detectedClass"]]!]!.color,
          onPressed: () {
            _setGarbage(garbages[result["detectedClass"]]!);
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
