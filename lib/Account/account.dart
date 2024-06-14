import 'dart:convert';
import 'package:navette/Common/NoDataPage.dart';
import 'package:navette/Common/loadingPage.dart';
import 'package:navette/Helpers/CityHelper.dart';
import 'package:navette/Helpers/PreferenceHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navette/Account/personnalInfo.dart';
import 'package:navette/Account/vehicleInfo.dart';
import 'package:navette/Account/itirenaryInfo.dart';

/// Page du compte utilisateur ou de la liste des utilisateurs selon ce qui est sélectionné
class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);
  @override
  State<Account> createState() {
    return _AccountState();
  }
}

class _AccountState extends State<Account> {
  int userId = -1;
  List<dynamic> jsonData = [];
  Map<String, dynamic> selectedUserData = {};
  PreferenceHelper pref = PreferenceHelper();
  bool isLoading = true;

  @override
  void initState() {
    PreferenceHelper.init().then((value) {
      setState(() {
        isLoading = false;
        userId = PreferenceHelper.userId;
      });
    });
    super.initState();
  }

  /// Récupère les infos de tout les utilisateurs
  Future<List<dynamic>> fetchUserData() async {
    var url = Uri.parse('${PreferenceHelper.navetteApi}api/v1/user/');

    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;charset=UTF-8',
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

  /// récupère lkes infos de l'utilisateur sélectionné
  Future<Map<String, dynamic>> fetchSelectedUserData() async {
    var url = Uri.parse('${PreferenceHelper.navetteApi}api/v1/user/$userId');

    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      if (response.statusCode == 200) {
        selectedUserData = json.decode(response.body);
        CityHelper.villeD = selectedUserData['city']['id'];
        CityHelper.zone = selectedUserData['zone']['id'];
        CityHelper.stop = selectedUserData['stop']['id'];
        CityHelper.villeA = 1;
        await PreferenceHelper.setBoolValue(
            PreferenceHelper.isVerifiedKey, selectedUserData['verified']);
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
  Widget build(BuildContext context) {
    return (isLoading)
        ? const LoadingPage()
        : (userId != -1)
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
                                  backgroundImage:
                                      AssetImage("assets/logo.png"),
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              PersonnalInfo(
                                name: selectedUserData['name'],
                                mail: selectedUserData['email'],
                              ),
                              (selectedUserData['verified'] as bool)
                                  ? VehicleInfo(
                                      modele:
                                          selectedUserData['vehicle_model'] ??
                                              '',
                                      couleur:
                                          selectedUserData['vehicle_color'] ??
                                              '',
                                      plaque: selectedUserData[
                                              'vehicle_registration'] ??
                                          '',
                                    )
                                  : Container(),
                              ItirenaryInfo(
                                city: selectedUserData['city'] != null
                                    ? selectedUserData['city']['id']
                                    : -1,
                                zone: selectedUserData['zone'] != null
                                    ? selectedUserData['zone']['id']
                                    : -1,
                                stop: selectedUserData['stop'] != null
                                    ? selectedUserData['stop']['id']
                                    : -1,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    PreferenceHelper.setUserId(-1);
                                    userId = -1;
                                  });
                                },
                                icon: const Icon(Icons.change_circle_outlined),
                                label: const Text('Changer d\'utilisateur'),
                              )
                            ]),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Erreur');
                  } else {
                    return const LoadingPage();
                  }
                },
              )
            : FutureBuilder(
                future: fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return NoDataPage();
                    } else {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Liste des Utilisateurs'),
                        ),
                        body: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userData =
                                snapshot.data![index];
                            return ListTile(
                                title: Text(userData['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(userData['email']),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  child: Text(userData['name'].substring(0, 1)),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  setState(() {
                                    userId = snapshot.data![index]['id'];
                                    PreferenceHelper.setUserId(userId);
                                  });
                                });
                          },
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Text('Erreur');
                  } else {
                    return const LoadingPage();
                  }
                });
  }
}
