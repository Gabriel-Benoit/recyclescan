import 'dart:collection';
import 'dart:ui';

import 'package:recyclescan/garbage.dart';

class Rule {
  final String name;
  final String imageUrl;
  final Color color;
  final bool? isImageAsset;
  const Rule(
      {required this.name,
      required this.imageUrl,
      required this.color,
      this.isImageAsset});

  static Map<Garbage, Rule> fromJSON(String path) {
    return LinkedHashMap.identity();
  }
}
