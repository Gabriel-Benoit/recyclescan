import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:recyclescan/garbage.dart';

class Rule {
  final String name;
  final String imageUrl;
  final Color color;

  const Rule({required this.name, required this.imageUrl, required this.color});

  static Future<Map<Garbage, Rule>> fromJSON(String path)  async {
    // Load data from json file and wait for result
    String data = await rootBundle.loadString(path);
    final jsonRules = json.decode(data);

    // Init and fill rules map
    Map<Garbage, Rule> rules = {};
    for(var i = 0 ; i < jsonRules.length;i++) {
      // Find corresponding garbage
      Garbage gb = garbages[jsonRules[i]["garbage"]];

      // Match correct color (String -> Color)
      String colStr = jsonRules[i]["color"];
      Color color;
      switch(colStr) {
        case "blue": {color = Colors.blue;}
          break;
        case "yellow": {color = Colors.yellow;}
          break;
        case "green": {color = Colors.green;}
          break;
        default:{color = Colors.grey;}
          break;
      }
      // Add new rule in the map
      rules[gb] = Rule(name: jsonRules[i]["name"], imageUrl:jsonRules[i]["imageUrl"], color: color);
    }

    return rules;
  }
}
