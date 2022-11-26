import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:recyclescan/utils/customclosebutton.dart';

import '../garbage.dart';
import '../rule.dart';

/// Widget qui affiche le déchet identifié ainsi que la
/// manière de trier celui-ci mais également des conseils
/// concerant le tri et des redirections si nécessaire
/// (matériaux ambigu comme l'indentification d'une bouteille
/// en plastique ou en verre par exemple).
class WasteDescription extends StatelessWidget {
  final Garbage garbage;

  final Rule rule;
  final void Function() closeCallBack;
  final void Function(Garbage?) changeGarbageCallBack;

  const WasteDescription(
      {super.key,
      required this.garbage,
      required this.rule,
      required this.closeCallBack,
      required this.changeGarbageCallBack});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var imgWidth = 2 * size.width / 3;
    var imgHeight = 2 * size.width / 3;
    var alternatives_ = alternatives[garbage] ?? {};
    var comments_ = comments[garbage] ?? [];

    // Ajout des question avec redirections
    List<Widget> questions = alternatives_.entries.map((entry) {
      return _genCarouselElem(entry.key, () {
        changeGarbageCallBack(entry.value);
      }, TextDecoration.underline);
    }).toList();

    // Ajout des commentaires
    List<Widget> coms = comments_.map((com) {
      return _genCarouselElem(com, null, TextDecoration.none);
    }).toList();

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Positioned(
            top: 3,
            right: 3,
            child: CustomCloseButton(closeCallBack: closeCallBack),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [
                    const Text(
                      "Où jeter ce déchet ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      rule.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: rule.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                WrappedImage(
                    height: imgHeight,
                    width: imgWidth,
                    provider: rule.image,
                    semanticLabel: "Rule picture"),
                CarouselSlider(
                  items: [...questions, ...coms],
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget helper pour afficher correctement une image dans le
/// contexte d'utilisation dans le widget ```WasteDescription```
class WrappedImage extends StatelessWidget {
  final ImageProvider provider;
  final String semanticLabel;
  final double height;
  final double width;

  const WrappedImage(
      {super.key,
      required this.provider,
      required this.semanticLabel,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image(
        image: provider,
        semanticLabel: semanticLabel,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Center(child: CircularProgressIndicator());
        },
        fit: BoxFit.cover,
      ),
    );
  }
}

/// Focntion utilitaire pour générer un élément du carousel dans le
/// widget ```WasteDescription```
///
/// Params:
/// -------
/// - text: le texte à afficher
/// - onTap: le callback à passer si on veut faire une redirection
///
/// Return:
/// -------
/// - un widget correctement formatté en fonction des paramètres
Widget _genCarouselElem(
    String text, void Function()? onTap, TextDecoration textDecoration) {
  return Builder(builder: (ctx) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox.expand(
        child: Container(
          color: Color.fromARGB(255, 245, 245, 245),
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  text,

                  //overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      letterSpacing: 1.5,
                      color:
                          Color.fromARGB(255, 80, 80, 80), //Colors.lightGreen,
                      decoration: textDecoration),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });
}
