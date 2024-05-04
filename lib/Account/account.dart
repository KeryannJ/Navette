import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:application/Account/personnalInfo.dart';
import 'package:application/Account/vehicleInfo.dart';
import 'package:application/Account/itirenaryInfo.dart';
import 'package:application/Helpers/preferenceHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;
  @override
  State<Account> createState() {
    return _AccountState();
  }
}

class _AccountState extends State<Account> {
  int userId = -1;
  List<dynamic> jsonData = [];
  Map<String, dynamic> selectedUserData = {};

  Future<List<dynamic>> fetchUserData() async {
    var url = Uri.parse('${PreferenceHelper.navetteApi}api/v1/user/');

    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw ErrorDescription(
            ' Erreur de récupération code d\'erreur = ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<Map<String, dynamic>> fetchSelectedUserData() async {
    var url = Uri.parse('${PreferenceHelper.navetteApi}api/v1/user/$userId');

    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      if (response.statusCode == 200) {
        selectedUserData = json.decode(response.body);
        return selectedUserData;
      } else {
        throw ErrorDescription(
            ' Erreur de récupération code d\'erreur = ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  @override
  void initState() {
    PreferenceHelper.setPrefs(widget.prefs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (userId != -1)
        ? FutureBuilder(
            future: fetchSelectedUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage("assets/logo.png"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                (selectedUserData['verified'] as bool)
                                    ? Icons.verified
                                    : Icons.close,
                                size: 30,
                              ),
                              Text(
                                (selectedUserData['verified'] as bool)
                                    ? 'Vérifié'
                                    : 'Non Vérifié',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        PersonnalInfo(
                          name: selectedUserData['name'],
                          mail: selectedUserData['email'],
                        ),
                        VehicleInfo(
                          modele: selectedUserData['vehicle_model'],
                          couleur: selectedUserData['vehicle_color'],
                          plaque: selectedUserData['vehicle_registration'],
                        ),
                        ItirenaryInfo(
                          city: selectedUserData['city']['id'],
                          zone: selectedUserData['zone']['id'],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text('Erreur');
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
        : FutureBuilder(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Liste des Utilisateurs'),
                  ),
                  body: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> userData = snapshot.data![index];
                      return ListTile(
                          title: Text(userData['name']),
                          onTap: () {
                            setState(() {
                              userId = snapshot.data![index]['id'];
                            });
                          });
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text('Erreur');
              } else {
                return const Scaffold(body: CircularProgressIndicator());
              }
            });
  }
}
