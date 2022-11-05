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
void initCities() async {
  cities.add(
    City(
      name: "Namur",
      postalCode: 5000,
      rules: await Rule.fromJSON(
          "assets/Namur_garbages.json", "assets/Namur_rules.json"),
    ),
  );
}
