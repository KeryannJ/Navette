import 'package:application/Account/ItirenaryInfo.dart';
import 'package:flutter/material.dart';
import 'package:application/Account/personnalInfo.dart';
import 'package:application/Account/vehicleInfo.dart';

class Account extends StatelessWidget {
  const Account({super.key});

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
