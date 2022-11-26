import 'package:flutter/material.dart';

/// Widget d'affichage de texte permettant le changement du texte de
/// manière dynamique
class DynamicText extends StatefulWidget {
  final TextStyle? style;
  final String text;
  const DynamicText(this.text, {super.key, this.style});

  @override
  State<StatefulWidget> createState() => DynamicTextState();
}

class DynamicTextState extends State<DynamicText> {
  /// Permet de mettre à jour le texte à afficher
  ///
  /// Params:
  /// -------
  /// - text: le nouveau texte
  setText(String text) {
    setState(() {
      _text = text;
    });
  }

  /// Permet d'afficher le texte par défaut ("RecycleScan")
  defaultText() {
    setText("RecycleScan");
  }

  late String _text;

  @override
  void initState() {
    super.initState();
    _text = "RecycleScan";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: widget.style,
    );
  }
}
