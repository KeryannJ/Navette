import 'package:application/Helpers/PreferenceHelper.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  TextEditingController navette = TextEditingController();
  TextEditingController maps = TextEditingController();

  @override
  void initState() {
    navette.text = PreferenceHelper.navetteApi;
    maps.text = PreferenceHelper.mapsApi;
    super.initState();
  }

  @override
  void dispose() {
    PreferenceHelper.setAPIValues(navette.text, maps.text);
    navette.dispose();
    maps.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Paramètres",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 300,
            child: TextField(
              controller: navette,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'API Navette',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 300,
            child: TextField(
              controller: maps,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'API Google Maps',
              ),
            ),
          ),
        )
      ],
    ));
  }
}
