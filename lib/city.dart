import 'package:recyclescan/garbage.dart';
import 'package:recyclescan/rule.dart';

class City {
  final int postalCode;
  final String name;
  final Map<Garbage, Rule> rules;

  const City(
      {required this.postalCode, required this.name, required this.rules});
}

final List<City> cities = [];
initCities(rules) {
  cities.add(
    City(
      name: "Namur",
      postalCode: 5000,
      rules: rules,
    ),
  );
}
