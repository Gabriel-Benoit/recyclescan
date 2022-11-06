import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'city.dart';
import 'detector/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initCities();
  final cameras = await availableCameras();

  final camera = cameras.first;

  runApp(MaterialApp(
    title: 'RecycleScan',
    theme: ThemeData(
      primarySwatch: Colors.green,
      bottomAppBarColor: Colors.green,
    ),
    home: WidgetMananger(camera: camera),
  ));
}

class WidgetMananger extends StatefulWidget {
  final CameraDescription camera;
  const WidgetMananger({super.key, required this.camera});

  @override
  State<StatefulWidget> createState() => _WidgetManangerState();
}

class _WidgetManangerState extends State<WidgetMananger> {
  Widget _currentWidget = Container();

  @override
  void initState() {
    super.initState();
    _currentWidget = HomePage(camera: widget.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RecycleScan')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                'RecycleScan',
                style: TextStyle(color: Colors.lightGreen),
              ),
            ),
            ListTile(
              onTap: (() {}),
            )
          ],
        ),
      ),
      body: _currentWidget,
    );
  }
}
