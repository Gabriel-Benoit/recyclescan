import 'dart:convert';
import 'package:flutter/painting.dart';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:recyclescan/garbage.dart';

class Rule {
  final String name;
  final ImageProvider image;
  final Color color;

  const Rule({required this.name, required this.image, required this.color});

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
          image: NetworkImage(jsonRules[ruleId]["imageUrl"]),
          color: color);
    }

    return rules;
  }
}
