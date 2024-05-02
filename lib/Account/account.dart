import 'dart:convert';
import 'package:application/Account/ItirenaryInfo.dart';
import 'package:application/Helpers/PreferenceHelper.dart';
import 'package:flutter/material.dart';
import 'package:application/Account/personnalInfo.dart';
import 'package:application/Account/vehicleInfo.dart';
import 'package:http/http.dart' as http;

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _Account();
}

class _Account extends State<Account> {
  int userId = -1;

  Future<void> fetchUserData() async {
    var url = Uri.parse('${PreferenceHelper.navetteApi}/api/v1/user');

    try {
      http.Response response = await http.get(url);
      // TODO Tester la réponse
      if (response.statusCode == 200) {
        var data = JsonDecoder(
            response.body as Object? Function(Object? key, Object? value)?);
        print(data);
      } else {
        print('rien');
      }
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    if (userId != -1) {}
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/logo.png"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified,
                  size: 30,
                ),
                Text(
                  "Vérifié",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )
              ],
            ),
          ),
          PersonnalInfo(),
          VehicleInfo(),
          ItirenaryInfo(),
        ],
      ),
    ));
  }
}
