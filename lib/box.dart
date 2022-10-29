import 'package:flutter/material.dart';

/// Widget Wrapper représentant une box qui identifie un déchet et
/// qui permet d'afficher une description qui donne une directive de tri
class BoxWithBorder extends StatelessWidget {
  BoxWithBorder({super.key, required this.height, required this.width, required this.posX, required this.posY}){
    description = const WasteDescription();
  }
  final double height;
  final double width;
  final double posX;
  final double posY;
  late final WasteDescription description;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: posX,
      top: posY,
      child: SizedBox(
        height: height,
        width: width,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2.0),
          ),
          child: Opacity(
            opacity: 1.0,
            child: Box(description: description,),
          ),
        ),
      ),
    );
  }
}

class Box extends StatefulWidget {
  const Box({super.key, required this.description });
  final WasteDescription description;
  @override
  State<StatefulWidget> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  bool _isDescriptionOpened = false;
  _openDescription(){
    setState(() {
      _isDescriptionOpened = !_isDescriptionOpened;
      if(_isDescriptionOpened){
        widget.description.open();
      } else {
        widget.description.close();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: _openDescription);
  }
}

class WasteDescription extends StatefulWidget {
  const WasteDescription({super.key});
  open(){
    print("Opening description");
  }
  close(){
    print("Closing description");
  }
  
  @override
  State<StatefulWidget> createState() => _WasteDescriptionState();

}

class _WasteDescriptionState extends State<WasteDescription> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
}
