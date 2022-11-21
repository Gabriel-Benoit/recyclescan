import 'package:flutter/material.dart';

class DynamicText extends StatefulWidget {
  final TextStyle? style;
  final String text;
  const DynamicText(this.text, {super.key, this.style});

  @override
  State<StatefulWidget> createState() => DynamicTextState();
}

class DynamicTextState extends State<DynamicText> {
  setText(String text) {
    setState(() {
      _text = text;
    });
  }

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
