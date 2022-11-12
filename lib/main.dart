import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:recyclescan/location/locationpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'city.dart';
import 'detector/home.dart';
import 'utils/placeholder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initCities();
  final cameras = await availableCameras();
  final prefs = await SharedPreferences.getInstance();
  //await prefs.remove("location");
  final camera = cameras.first;

  runApp(
    MaterialApp(
      title: 'RecycleScan',
      theme: ThemeData(
        primarySwatch: Colors.green,
        bottomAppBarColor: Colors.green,
      ),
      home: WidgetManager(
        camera: camera,
        prefs: prefs,
      ),
    ),
  );
}

class WidgetManager extends StatefulWidget {
  final CameraDescription camera;
  final SharedPreferences prefs;
  const WidgetManager({super.key, required this.camera, required this.prefs});

  @override
  State<StatefulWidget> createState() => _WidgetManagerState();
}

class _WidgetManagerState extends State<WidgetManager> {
  Widget _currentWidget = Container();
  final _tileStyle = ListTileStyle.list;

  void _setWidget(Widget w, {bool popCtx = true}) {
    setState(() {
      _currentWidget = w;
    });
    if (popCtx) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.prefs.getStringList("location") == null) {
      _currentWidget = LocationPage(
        okHandler: () =>
            _setWidget(HomePage(camera: widget.camera), popCtx: false),
        prefs: widget.prefs,
      );
    } else {
      _currentWidget = HomePage(camera: widget.camera);
    }
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
              onTap: (() => _setWidget(HomePage(camera: widget.camera))),
            ),
            ListTile(
              title: const Text("Signaler un déchet mal identifié"),
              style: _tileStyle,
              textColor: Colors.lightGreen,
              onTap: (() => _setWidget(const PlaceHolder())),
            ),
            ListTile(
              title: const Text("A propos de nous"),
              style: _tileStyle,
              textColor: Colors.lightGreen,
              onTap: (() => _setWidget(const PlaceHolder())),
            ),
            ListTile(
              title: const Text("Changer ma province"),
              style: _tileStyle,
              textColor: Colors.lightGreen,
              onTap: (() => _setWidget(
                    LocationPage(
                      okHandler: () => _setWidget(
                          HomePage(camera: widget.camera),
                          popCtx: false),
                      prefs: widget.prefs,
                    ),
                  )),
            )
          ],
        ),
      ),
      body: _currentWidget,
    );
  }
}
