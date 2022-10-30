import 'package:flutter/material.dart';

/// Widget Wrapper représentant une box qui identifie un déchet et
/// qui permet d'afficher une description qui donne une directive de tri
class BoxWithBorder extends StatefulWidget {
  const BoxWithBorder(
      {super.key,
      required this.height,
      required this.width,
      required this.posX,
      required this.posY});

  final double height;
  final double width;
  final double posX;
  final double posY;

  @override
  State<StatefulWidget> createState() => _BoxWithBorderState();
}

class _BoxWithBorderState extends State<BoxWithBorder> {
  bool isDescOpen = false;

  void _toggleDescription() {
    setState(() {
      isDescOpen = !isDescOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isDescOpen) {
      return Positioned(
        left: widget.posX,
        top: widget.posY,
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2.0),
            ),
            child: Box(
              parent: widget,
              onPressed: _toggleDescription,
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2.0),
        ),
        child: WasteDescription(
          closeCallBack: _toggleDescription,
        ),
      );
    }
  }
}

class Box extends StatefulWidget {
  const Box({super.key, required this.parent, required this.onPressed});

  final void Function() onPressed;
  final BoxWithBorder parent;
  @override
  State<StatefulWidget> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: widget.onPressed);
  }
}

class WasteDescription extends StatelessWidget {
  WasteDescription({super.key, required this.closeCallBack});

  void Function() closeCallBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
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
