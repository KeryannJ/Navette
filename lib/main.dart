import 'dart:async';
import 'dart:ui';
import 'package:navette/Driver/driver.dart';
import 'package:navette/Helpers/BeaconHelper.dart';
import 'package:navette/Helpers/CityHelper.dart';
import 'package:navette/Helpers/PreferenceHelper.dart';
import 'package:navette/History/history.dart';
import 'package:navette/Itinerary/itinerary.dart';
import 'package:navette/Account/account.dart';
import 'package:navette/Service/BeaconService.dart';
import 'package:navette/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceHelper.init();
  await CityHelper.fetchCityAndZoneAndStop();
  await CityHelper.getUserItirenaryInfo();
  var status = await Permission.locationWhenInUse.request();
  status = await Permission.locationAlways.request();
  status = await Permission.bluetoothScan.request();
  status = await Permission.bluetoothConnect.request();
  status = await Permission.notification.request();
  if (CityHelper.villesDict.isNotEmpty) {
    BeaconService.initializeService();
  }
  runApp(const MaterialApp(home: Navette()));
}

class Navette extends StatefulWidget {
  const Navette({super.key});

  @override
  State<Navette> createState() => NavetteState();
}

class NavetteState extends State<Navette> with TickerProviderStateMixin {
  late TabController tabC;
  late Timer timer;

  @override
  void initState() {
    tabC =
        TabController(length: PreferenceHelper.isVerified ? 3 : 2, vsync: this);
    super.initState();
  }

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
      pageBuilder: (context, animation, secondaryAnimation) => const Account(),
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
        length: PreferenceHelper.isVerified ? 3 : 2,
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
                Row(children: [
                  IconButton(
                      onPressed: () async {
                        await Navigator.of(context).push(showAccount());
                        await PreferenceHelper.init();
                        setState(() {
                          tabC = TabController(
                              length: PreferenceHelper.isVerified ? 3 : 2,
                              vsync: this);
                        });
                      },
                      icon: const Icon(Icons.account_circle)),
                  IconButton(
                      icon: const Icon(Icons.settings_rounded),
                      onPressed: () async {
                        await Navigator.of(context).push(showSettings());
                        await PreferenceHelper.init();
                        await CityHelper.fetchCityAndZoneAndStop();
                        await BeaconHelper.fetchUserBeacon();
                        final service = FlutterBackgroundService();

                        if (CityHelper.villesDict.isNotEmpty &&
                            !await service.isRunning()) {
                          BeaconService.initializeService();
                        }
                      }),
                ])
              ],
            ),
            bottom: TabBar(
              onTap: (value) {
                if (!CityHelper.travelOngoing) {
                  tabC.animateTo(value);
                }
              },
              tabs: PreferenceHelper.isVerified
                  ? const [
                      Tab(text: 'Itinéraire', icon: Icon(Icons.transform)),
                      Tab(text: 'Conducteur', icon: Icon(Icons.directions_car)),
                      Tab(text: 'Historique', icon: Icon(Icons.history)),
                    ]
                  : const [
                      Tab(text: 'Itinéraire', icon: Icon(Icons.transform)),
                      Tab(text: 'Historique', icon: Icon(Icons.history)),
                    ],
            ),
          ),
          body: TabBarView(
            controller: tabC,
            physics: const NeverScrollableScrollPhysics(),
            children: PreferenceHelper.isVerified
                ? const [
                    Itineraire(),
                    Driver(),
                    History(),
                  ]
                : const [
                    Itineraire(),
                    History(),
                  ],
          ),
        ),
      ),
    );
  }
}
