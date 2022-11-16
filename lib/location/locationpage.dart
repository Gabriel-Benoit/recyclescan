import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const provinces = <String>[
  "Namur",
  "Liège",
  "Hainaut",
  "Brabant Wallon",
  "Luxembourg",
  "Bruxelles"
];

class LocationPage extends StatefulWidget {
  final SharedPreferences prefs;
  final void Function() okHandler;

  const LocationPage({super.key, required this.prefs, required this.okHandler});

  @override
  State<StatefulWidget> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late String province;

  _saveLocation() {
    widget.prefs.setString("location", province);
  }

  @override
  void initState() {
    super.initState();
    province = widget.prefs.getString("location") ?? "Namur";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Choisissez votre province:",
                  style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  value: province,
                  items: provinces.map<DropdownMenuItem>((String e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (e) {
                    setState(() {
                      province = e;
                    });
                  },
                ),
                TextButton(
                  onPressed: () {
                    _saveLocation();
                    widget.okHandler();
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 20, horizontal: 56)),
                    shadowColor: MaterialStatePropertyAll(Colors.black),
                    overlayColor: MaterialStatePropertyAll(Colors.lightGreen),
                  ),
                  child: const Text(
                    "Sauvegarder",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
