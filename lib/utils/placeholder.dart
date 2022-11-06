import 'package:flutter/material.dart';

class PlaceHolder extends StatelessWidget {
  const PlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(color: Colors.blueGrey),
      child: Center(
        child: Column(
          children: const [
            Expanded(
              child: Text("Placeholder"),
            ),
          ],
        ),
      ),
    );
  }
}
