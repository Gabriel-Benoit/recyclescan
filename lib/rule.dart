import 'package:flutter/painting.dart';
import 'dart:collection';

import 'package:recyclescan/garbage.dart';

class Rule {
  final String name;
  final ImageProvider image;
  final Color color;

  const Rule({required this.name, required this.image, required this.color});

  static Map<Garbage, Rule> fromJSON(String path) {
    return LinkedHashMap.identity();
  }
}