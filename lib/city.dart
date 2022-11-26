import 'package:recyclescan/garbage.dart';
import 'package:recyclescan/rule.dart';

import 'utils/pair.dart';

/// Classe représentant une ville avec les règles de tri qui lui sont propres
class City {
  final int postalCode;
  final String name;
  final Map<Garbage, Rule> rules;

  const City(
      {required this.postalCode, required this.name, required this.rules});
}

/// Liste des villes à considérer.
/// La liste est remplie à l'aide de la fonction ```initCities```
final List<City> cities = [];

/// Permet de remplir la liste des villes
initCities(Map<String, Pair<int, Map<Garbage, Rule>>> rulesMap) {
  rulesMap.forEach((key, value) {
    cities.add(
      City(
        name: key,
        postalCode: value.first(),
        rules: value.second(),
      ),
    );
  });
}
