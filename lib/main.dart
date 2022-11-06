import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'city.dart';
import 'detector/home.dart';
import 'utils/placeholder.dart';

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
    home: WidgetManager(camera: camera),
  ));
}

class WidgetManager extends StatefulWidget {
  final CameraDescription camera;
  const WidgetManager({super.key, required this.camera});

  @override
  State<StatefulWidget> createState() => _WidgetManagerState();
}

class _WidgetManagerState extends State<WidgetManager> {
  Widget _currentWidget = Container();
  final _tileStyle = ListTileStyle.drawer;

  void _setWidget(Widget w){
    setState(() {
      _currentWidget = w;
    });
    Navigator.pop(context);
  }

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
              title: const Text("Camera"),
              style: _tileStyle,
              textColor: Colors.lightGreen,
              onTap: (() =>
                 _setWidget(HomePage(camera: widget.camera))
              ),
            ),
            ListTile(
              title: const Text("A propos de nous"),
              style: _tileStyle,
              textColor: Colors.lightGreen,
              onTap: (() =>
                  _setWidget(const PlaceHolder())
              ),
            )
          ],
        ),
      ),
      body: _currentWidget,
    );
  }
}
