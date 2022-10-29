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
  late imglib.Image img;
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
              img = ImageUtils.convertYUV420ToImage(image);
              await ssdMobileNet(img);
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
          File('/storage/emulated/0/thumbnail-test.png').writeAsBytesSync(imglib.encodePng(img));
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future ssdMobileNet(imglib.Image img) async {
    var recognitions = await Tflite.detectObjectOnBinary(
      binary: ImageUtils.imageToByteListUint8(
        imglib.copyResize(img, width:300, height:300), 300
      ),
      numResultsPerClass: 1,
    );
    print(recognitions);
  }
}

/// ImageUtils
class ImageUtils {
  /// Converts a [CameraImage] in YUV420 format to [imglib.Image] in RGB format
  static imglib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = imglib.Image(width, height);

    for (int w = 0; w < width; w++) {
      for (int h = 0; h < height; h++) {
        final int uvIndex = uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final int index = h * width + w;

        final y = cameraImage.planes[0].bytes[index];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data[index] = ImageUtils.yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  /// Convert a single YUV pixel to RGB
  static int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    int r = (y + v * 1436 / 1024 - 179).round();
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    int b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  static Uint8List imageToByteListUint8(imglib.Image image, int inputSize) {
    var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
    var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = imglib.getRed(pixel);
        buffer[pixelIndex++] = imglib.getGreen(pixel);
        buffer[pixelIndex++] = imglib.getBlue(pixel);
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}