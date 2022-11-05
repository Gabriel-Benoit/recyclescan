// ignore_for_file: unnecessary_new

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
      decoration: const BoxDecoration(color: Colors.lightGreen),
      child: Stack(
        children: [
          Positioned(
            top: 3,
            left: 3,
            child: SizedBox.square(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(90),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5, color: Colors.black.withOpacity(0.5)),
                    ]),
                child: CloseButton(
                  onPressed: closeCallBack,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                "Déchet identifié: ${garbage.name}",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 5, color: Colors.greenAccent)],
                ),
              ),
              WrappedImage(
                  provider: garbage.image, semanticLabel: "Garbage picture"),
              Text(
                "Politique de tri: ${rule.name}",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 5, color: Colors.greenAccent)],
                ),
              ),
              WrappedImage(provider: rule.image, semanticLabel: "Rule picture"),
            ]),
          ),
        ],
      ),
    );
  }
}

class WrappedImage extends StatelessWidget {
  final ImageProvider provider;
  final String semanticLabel;

  const WrappedImage(
      {super.key, required this.provider, required this.semanticLabel});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: provider,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
