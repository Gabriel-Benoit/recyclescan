import 'package:flutter/material.dart';
import 'package:recyclescan/utils/customclosebutton.dart';

import '../garbage.dart';
import '../rule.dart';

class WasteDescription extends StatelessWidget {
  final Garbage garbage;

  final Rule rule;
  final void Function() closeCallBack;
  final void Function(Garbage?) changeGarbageCallBack;
  final TextStyle _style = const TextStyle(
    fontSize: 24,
    color: Colors.lightGreen,
    fontWeight: FontWeight.bold,
  );

  const WasteDescription(
      {super.key,
      required this.garbage,
      required this.rule,
      required this.closeCallBack,
      required this.changeGarbageCallBack});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var alternatives_ = alternatives[garbage] ?? {};
    var comments_ = comments[garbage] ?? [];
    List<Widget> advice = alternatives_.entries.map((entry) {
      var garbage = entry.value;
      var txt = entry.key;
      return GestureDetector(
        onTap: (() {
          changeGarbageCallBack(garbage);
        }),
        child: AdviceText(
          text: txt,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.lightGreen,
              decoration: TextDecoration.underline),
        ),
      );
    }).toList();
    advice.addAll(comments_.map((com) {
      return GestureDetector(
        child: AdviceText(
          text: com,
          style: const TextStyle(fontSize: 18, color: Colors.lightGreen),
        ),
      );
    }).toList());
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Positioned(
            bottom: 3,
            right: 3,
            child: CustomCloseButton(closeCallBack: closeCallBack),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Déchet identifié: ${garbage.name}",
                  textAlign: TextAlign.center,
                  style: _style,
                ),
                WrappedImage(
                    provider: garbage.image, semanticLabel: "Garbage picture"),
                Text(
                  "Politique de tri: ${rule.name}",
                  textAlign: TextAlign.center,
                  style: _style,
                ),
                WrappedImage(
                    provider: rule.image, semanticLabel: "Rule picture"),
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
    return SizedBox(
      width: 100,
      height: 200,
      child: Image(
        image: provider,
        semanticLabel: semanticLabel,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Center(child: CircularProgressIndicator());
        },
        fit: BoxFit.fill,
      ),
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

bottomSheetDisplay(List<GestureDetector> advice) {
  return (BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(),
      child: Center(
        child: Column(
          children: advice,
        ),
      ),
    );
  };
}
