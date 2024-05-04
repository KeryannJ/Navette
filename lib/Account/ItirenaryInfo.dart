import 'dart:convert';

import 'package:application/Common/dropDownMenu.dart';
import 'package:application/Helpers/PreferenceHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItirenaryInfo extends StatefulWidget {
  const ItirenaryInfo({super.key, required this.city, required this.zone});
  final int city;
  final int zone;

  @override
  State<ItirenaryInfo> createState() => _ItirenaryInfo();
}

class _ItirenaryInfo extends State<ItirenaryInfo> {
  int cityToFind = -1;
  Map<int, String> villesDict = {};
  List<String> villes = [];
  List<String> currentZones = [];

  Future<List<dynamic>> fetchCityAndZone() async {
    var url = Uri.parse('${PreferenceHelper.navetteApi}api/v1/city/');

    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      if (response.statusCode == 200) {
        Uri urlZone;
        if (cityToFind == -1) {
          urlZone = Uri.parse(
              '${PreferenceHelper.navetteApi}api/v1/city/${widget.city}');
        } else {
          urlZone = Uri.parse(
              '${PreferenceHelper.navetteApi}api/v1/city/$cityToFind');
        }
        http.Response responseZone = await http.get(urlZone, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${PreferenceHelper.bearer}'
        });
        if (responseZone.statusCode == 200) {
          var data = json.decode(responseZone.body);
          if (data['zones'] != null) {
            for (var zone in data['zones']) {
              if (zone['id'] == widget.zone) {
                currentZones = [zone['name'] as String] + currentZones;
              } else {
                currentZones.add(zone['name']);
              }
            }
          }
        }
        return json.decode(response.body);
      } else {
        throw ErrorDescription(
            ' Erreur de récupération code d\'erreur = ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  void changeZone(String ville) {
    for (var city in villesDict.entries) {
      if (ville == city.value) {
        setState(() {
          villesDict.clear();
          currentZones.clear();
          villes.clear();
          cityToFind = city.key;
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCityAndZone(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          villes.clear();
          villesDict.clear();
          for (var ville in snapshot.data!) {
            villesDict.putIfAbsent(ville['id'], () => ville['name']);
            if ((cityToFind == -1 && ville['id'] == widget.city) ||
                (cityToFind != -1 && ville['id'] == cityToFind)) {
              villes = [ville['name'] as String] + villes;
            } else {
              villes.add(ville['name']);
            }
          }
          return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              height: 180,
              width: 500,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(children: [
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map),
                      Text(
                        "Itinéraire",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 75,
                          width: 75,
                        ),
                        MyDropDownMenu(items: villes, changeZone: changeZone),
                      ]),
                      const Icon(
                        Icons.arrow_circle_right,
                        size: 30,
                      ),
                      Column(children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 75,
                          width: 75,
                        ),
                        MyDropDownMenu(items: currentZones),
                      ])
                    ]),
              ]));
        } else if (snapshot.hasError) {
          return const Text('Erreur');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
