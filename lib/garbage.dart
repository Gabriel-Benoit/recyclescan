import 'package:flutter/painting.dart';

// Classe représentant un déchet (avec un nom et une image)
// Cette image peut être locale ou en ligne
class Garbage {
  final String name;
  final ImageProvider image;

  const Garbage({
    required this.name,
    required this.image,
  });
}

// Liste de tous les déchets gérés par l'application
final Map<String, Garbage> garbages = {
  "can": const Garbage(
      name: "Canette",
      image: NetworkImage(
          "https://upload.wikimedia.org/wikipedia/commons/6/6c/Tolkki20091027.jpg")),
  "bottle": const Garbage(
      name: "Bouteille",
      image: NetworkImage(
          "https://upload.wikimedia.org/wikipedia/commons/e/e5/Evian_Bottle.jpg")),
  "glassbottle": const Garbage(
      name: "Bouteille en verre",
      image: NetworkImage(
          "https://upload.wikimedia.org/wikipedia/commons/0/03/Green_glass_bottle_with_RFID_chip_Lagavulin_distillery-3192.jpg")),
  "pizzabox": const Garbage(
      name: "Carton à pizza",
      image: NetworkImage(
          "https://upload.wikimedia.org/wikipedia/commons/6/64/2020-02-21_12_39_16_Pizza_box_from_Buon_Appetito%27s_NY_Pizza_in_Dulles%2C_Loudoun_County%2C_Virginia.jpg")),
  "toothpaste": const Garbage(
      name: "Tube de dentifrice",
      image: NetworkImage(
          "https://upload.wikimedia.org/wikipedia/commons/3/34/Charcoal_Toothpaste.jpg")),
  "teabag": const Garbage(
      name: "Sachet de thé",
      image: NetworkImage(
          "https://upload.wikimedia.org/wikipedia/commons/e/e1/Tea_bag_777.jpg")),
  "paperteabag": const Garbage(
      name: "Sachet de thé en papier",
      image: NetworkImage(
          "https://upload.wikimedia.org/wikipedia/commons/e/e1/Tea_bag_777.jpg")),
};

// Dictionnaire où un déchet est mappé avec toutes ses alternatives
// Les alternatives sont identifiées par un String qui représente la question posée à l'utilisateur sur l'app
final Map<Garbage, Map<String, Garbage>> alternatives = {
  garbages["bottle"]!: {
    "Cette bouteille est en verre ?": garbages["glassbottle"]!,
  },
  garbages["teabag"]!: {"Ce sachet est en papier ?": garbages["paperteabag"]!}
};

// Dictionnaire où un déchet est mappé avec tout ses commentaires
final Map<Garbage, List<String>> comments = {
  garbages["toothpaste"]!: ["Le tube doit être vide."],
  garbages["bottle"]!: [
    "Si la bouteille contient des produits corrosifs et-ou toxiques, elle se trie au recyparc - DSM (déchets spéciaux des ménages)."
  ],
  garbages["glassbottle"]!: [
    "Les bouchons de bouteille de vin, de champagne et de cidre se trient au recyparc - bouchons de liège",
    "Les capsules métalliques se trient dans le sac bleu des PMC"
  ]
};
