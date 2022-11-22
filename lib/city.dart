import 'package:recyclescan/garbage.dart';
import 'package:recyclescan/rule.dart';

import 'utils/pair.dart';

class City {
  final int postalCode;
  final String name;
  final Map<Garbage, Rule> rules;

  const City(
      {required this.postalCode, required this.name, required this.rules});
}

final List<City> cities = [];
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
