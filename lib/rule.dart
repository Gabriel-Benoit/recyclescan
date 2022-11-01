import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:recyclescan/garbage.dart';

class Rule {
  final String name;
  final String imageUrl;
  final Color color;

  const Rule({required this.name, required this.imageUrl, required this.color});

  static Future<Map<Garbage, Rule>> fromJSON(String path)  async {
    String data = await rootBundle.loadString(path);
    final jsonRules = json.decode(data);
    
    Map<Garbage, Rule> rules = {};
    for(var i = 0 ; i < jsonRules.length();i++) {
      rules[jsonRules[i]["garbage"]] = Rule(name: jsonRules[i]["name"], imageUrl:jsonRules[i]["imageUrl"], color: jsonRules[i]["color"]);
    }
    return rules;
  }
}
