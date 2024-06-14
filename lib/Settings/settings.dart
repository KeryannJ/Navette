import 'package:navette/Common/loadingPage.dart';
import 'package:navette/Helpers/PreferenceHelper.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  TextEditingController navette = TextEditingController();
  TextEditingController bearer = TextEditingController();
  bool showPassword = false;
  bool isloading = true;
  PreferenceHelper pref = PreferenceHelper();

  @override
  void initState() {
    PreferenceHelper.init().then((value) {
      setState(() {
        isloading = false;
        navette.text = PreferenceHelper.navetteApi;
        bearer.text = PreferenceHelper.bearer;
      });
    });
    super.initState();
  }

  Future<void> savePrefs() async {
    if (!navette.text.startsWith('https://')) {
      navette.text = 'https://${navette.text}';
    }
    if (!navette.text.endsWith('/')) {
      navette.text = '${navette.text}/';
    }
    await PreferenceHelper.setAPIValues(navette.text, bearer.text);
  }

  @override
  void dispose() {
    bearer.dispose();
    navette.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (isloading)
        ? const LoadingPage()
        : Scaffold(
            body:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'API Navette',
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: bearer,
                        obscureText: !showPassword,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Bearer Navette',
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: Icon(showPassword
                            ? Icons.visibility_off
                            : Icons.visibility))
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                  width: 300,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await savePrefs();
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Sauvegarder et quitter'),
                  )),
            ),
          ]));
  }
}
