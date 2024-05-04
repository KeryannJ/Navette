import 'package:application/Driver/driver.dart';
import 'package:application/Helpers/PreferenceHelper.dart';
import 'package:application/History/history.dart';
import 'package:application/Itinerary/itinerary.dart';
import 'package:application/Account/account.dart';
import 'package:application/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initPreferences() async {
  PreferenceHelper.setPrefs(await SharedPreferences.getInstance());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPreferences();
  runApp(const MaterialApp(home: Navette()));
}

class Navette extends StatefulWidget {
  const Navette({super.key});

  @override
  State<Navette> createState() => NavetteState();
}

class NavetteState extends State<Navette> {
  Route showSettings() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Settings(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route showAccount() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Account(prefs: PreferenceHelper.prefs),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 70,
                  width: 70,
                ),
                const Text('Navette'),
                Row(children: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.notifications),
                    onSelected: (String result) {
                      // TODO gérer la sélection d'une notification
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Notif 1',
                        child: Text('Notif 1'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Notif 2',
                        child: Text('Notif 2'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Notif 3',
                        child: Text('Notif 3'),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(showAccount());
                      },
                      icon: const Icon(Icons.account_circle)),
                  IconButton(
                      icon: const Icon(Icons.settings_rounded),
                      onPressed: () {
                        Navigator.of(context).push(showSettings());
                      }),
                ])
              ],
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Itinéraire', icon: Icon(Icons.transform)),
                Tab(text: 'Conducteur', icon: Icon(Icons.directions_car)),
                Tab(text: 'Historique', icon: Icon(Icons.history)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Itineraire(),
              Driver(),
              History(),
            ],
          ),
        ),
      ),
    );
  }
}
