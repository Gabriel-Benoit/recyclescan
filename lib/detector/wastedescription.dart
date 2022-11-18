import 'package:flutter/material.dart';
import 'package:recyclescan/utils/customclosebutton.dart';

import '../garbage.dart';
import '../rule.dart';

class WasteDescription extends StatelessWidget {
  final Garbage garbage;
  final Rule rule;
  final void Function() closeCallBack;
  final TextStyle _style = const TextStyle(
    fontSize: 24,
    color: Colors.lightGreen,
    fontWeight: FontWeight.bold,
  );

  const WasteDescription(
      {super.key,
      required this.garbage,
      required this.rule,
      required this.closeCallBack});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> advice = garbage.comments.map((e) {
      return GestureDetector(
        onTap: e.second(),
        child: AdviceText(
          text: e.first(),
          style: TextStyle(
              fontSize: 18,
              color: Colors.lightGreen,
              decoration: e.second() == null ? TextDecoration.underline : null),
        ),
      );
    }).toList();

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Positioned(
            top: 3,
            left: 3,
            child: CustomCloseButton(closeCallBack: closeCallBack),
          ),
          Center(
            child: Table(
              columnWidths: {0: FractionColumnWidth(1), 1: FlexColumnWidth()},
              children: [
                TableRow(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Déchet identifié: ${garbage.name}",
                          textAlign: TextAlign.center,
                          style: _style,
                        ),
                        WrappedImage(
                            provider: garbage.image,
                            semanticLabel: "Garbage picture"),
                        Text(
                          "Politique de tri: ${rule.name}",
                          textAlign: TextAlign.center,
                          style: _style,
                        ),
                        WrappedImage(
                            provider: rule.image,
                            semanticLabel: "Rule picture"),
                      ],
                    ),
                    Column(
                      children: advice,
                    ),
                  ],
                )
              ],
            ),
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

class AdviceText extends StatelessWidget {
  final String? text;
  final TextStyle? style;

  const AdviceText({super.key, this.text, this.style});

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return const SizedBox.shrink();
    }
    return Text(
      text!,
      style: style,
    );
  }
}
