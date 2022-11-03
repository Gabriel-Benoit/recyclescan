import 'dart:io';

import 'package:flutter/material.dart';

import 'garbage.dart';
import 'rule.dart';

class WasteDescription extends StatelessWidget {
  final Garbage garbage;
  final Rule rule;
  final void Function() closeCallBack;

  const WasteDescription(
      {super.key,
      required this.garbage,
      required this.rule,
      required this.closeCallBack});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(color: rule.color),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: CloseButton(
              onPressed: closeCallBack,
              color: Colors.deepOrange,
            ),
          ),
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                "Déchet identifié: ${garbage.name}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Image(image: garbage.image, semanticLabel: "Garbage picture"),
              Text(
                "Politique de tri: ${rule.name}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Image(image: rule.image, semanticLabel: "Rule picture"),
            ]),
          ),
        ],
      ),
    );
  }
}
