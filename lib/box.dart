import 'package:flutter/material.dart';

/// Widget Wrapper représentant une box qui identifie un déchet et
/// qui permet d'afficher une description qui donne une directive de tri
class Box extends StatelessWidget {

  final double height;
  final double width;
  final double posX;
  final double posY;
  final Color color;
  final void Function() onPressed;

  const Box({
    super.key,
    required this.height,
    required this.width,
    required this.posX,
    required this.posY,
    required this.color,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: posX,
      top: posY,
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2.0),
        ),
        child: GestureDetector(onTap: onPressed),
      )
    );
  }
}
