import 'package:application/Helpers/PreferenceHelper.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  TextEditingController navette = TextEditingController();
  TextEditingController bearer = TextEditingController();

  @override
  void initState() {
    navette.text = PreferenceHelper.navetteApi;
    bearer.text = PreferenceHelper.bearer;
    super.initState();
  }

  void savePrefs() {
    PreferenceHelper.setAPIValues(navette.text, bearer.text);
  }

  @override
  void dispose() {
    savePrefs();
    bearer.dispose();
    navette.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            controller: bearer,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Bearer Navette',
            ),
          ),
        ),
      ),
    ]));
  }
}
