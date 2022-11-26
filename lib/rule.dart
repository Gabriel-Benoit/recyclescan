import 'dart:convert';
import 'package:flutter/painting.dart';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:recyclescan/garbage.dart';

/// Classe représentant une règle de tri avec (venant d'un fichier JSON):
class Rule {
  final String
      name; // Intitulé de la règle (Type de poubelle pour la collecte, ou dépot à la bulle à verre/recyparc)
  final ImageProvider image; // Image locale ou en ligne
  final Color
      color; // Couleur correspondant à la règle (bleu pour les PMC par exemple)

  const Rule({required this.name, required this.image, required this.color});

  /// Récupère les règles depuis 2 fichiers json et produit un dictionnaire qui associe une règle à chaque déchet
  ///
  /// Params:
  /// -------
  ///  - garbagesPath : chemin du fichier json qui associe un id de déchet à un id de règle
  ///  - rulesPath : chemin du fichier json qui liste toutes les règles
  ///
  /// Return:
  /// -------
  ///  - rules : objet Future qui contiendra le dictionnaire des règles au final
  ///
  static Future<Map<Garbage, Rule>> fromJSON(
      String garbagesPath, String rulesPath) async {
    // Load data from json file and wait for result
    String data = await rootBundle.loadString(garbagesPath);
    final jsonGarbages = json.decode(data);

    String data2 = await rootBundle.loadString(rulesPath);
    final jsonRules = json.decode(data2);

    // Init and fill rules map
    Map<Garbage, Rule> rules = {};
    for (var i = 0; i < garbages.length; i++) {
      // Find corresponding garbage
      Garbage gb = garbages[jsonGarbages[i]["garbage_id"]]!;
      var ruleId = jsonGarbages[i]["rule_id"];

      // Match correct color (String -> Color)
      String colStr = jsonRules[ruleId]["color"];
      Color color;
      switch (colStr) {
        case "blue":
          {
            color = Colors.blue;
          }
          break;
        case "yellow":
          {
            color = Colors.yellow;
          }
          break;
        case "green":
          {
            color = Colors.green;
          }
          break;
        default:
          {
            color = Colors.grey;
          }
          break;
      }
      // Add new rule in the map
      rules[gb] = Rule(
          name: jsonRules[ruleId]["name"],
          image: AssetImage(jsonRules[ruleId]["imageUrl"]),
          color: color);
    }
    return rules;
  }
}

/// Dictionnaire qui associe à chaque ville, toutes les règles relatives aux déchets gérés par l'app
Map<String, Map<Garbage, Rule>> rules = {};
Future<void> initRules() async {
  rules = {
    "Namur": await Rule.fromJSON(
        "assets/Namur_garbages.json", "assets/Namur_rules.json")
  };
}
