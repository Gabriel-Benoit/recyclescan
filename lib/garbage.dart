import 'package:flutter/painting.dart';

class Garbage {
  final String name;
  final ImageProvider  image;

  const Garbage({required this.name, required this.image});
}

final List<Garbage> garbages = [
  const Garbage(name: "Canette", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/6/6c/Tolkki20091027.jpg")),
  const Garbage(name: "Sachet de thé", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/e1/Tea_bag_777.jpg")),
  const Garbage(name: "Film en aluminium", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/b/bf/Aluminium_foil_ball.jpg")),
  const Garbage(name: "Carton à pizza", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/6/64/2020-02-21_12_39_16_Pizza_box_from_Buon_Appetito%27s_NY_Pizza_in_Dulles%2C_Loudoun_County%2C_Virginia.jpg")),
  const Garbage(name: "Essuie-tout", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/5/54/Paper_towel.jpg")),
  const Garbage(name: "Pneu de vélo", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/3/38/Bicycle_tire_-_Cheng_Shin.jpg")),
  const Garbage(name: "Classeur en plastique", image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/d/d9/Lever_arch_file.jpg"))
];