import 'package:flutter/painting.dart';

class Garbage {
  final String name;
  final ImageProvider image;

  const Garbage({required this.name, required this.image});
}

final List<Garbage> garbages = [
  const Garbage(name: "Canette", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/6/6c/Tolkki20091027.jpg"))
];