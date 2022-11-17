import 'package:flutter/painting.dart';

class Garbage {
  final String name;
  final ImageProvider image;

  const Garbage({required this.name, required this.image});
}

final List<Garbage> garbages = [
  const Garbage(name: "Canette", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/6/6c/Tolkki20091027.jpg")),
  const Garbage(name: "Bouteille", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/e5/Evian_Bottle.jpg")),
  const Garbage(name: "Carton à pizza", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/6/64/2020-02-21_12_39_16_Pizza_box_from_Buon_Appetito%27s_NY_Pizza_in_Dulles%2C_Loudoun_County%2C_Virginia.jpg")),
  const Garbage(name: "Tube de dentifrice", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/3/34/Charcoal_Toothpaste.jpg")),
  const Garbage(name: "Sachet de thé", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/e1/Tea_bag_777.jpg")),
];

