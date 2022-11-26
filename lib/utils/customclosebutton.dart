import 'package:flutter/material.dart';

/// Bouton de fermeture avec un style personnalisé
class CustomCloseButton extends StatelessWidget {
  final void Function() closeCallBack;
  const CustomCloseButton({super.key, required this.closeCallBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(90),
            boxShadow: [
              BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5)),
            ]),
        child: CloseButton(
          onPressed: closeCallBack,
          color: Colors.green,
        ),
      ),
    );
  }
}
