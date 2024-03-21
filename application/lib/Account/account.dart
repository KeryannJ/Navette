import 'package:application/Account/personnalInfo.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage("assets/logo.png"),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.verified), Text("Vérifié")]),
        PersonnalInfo(),
      ],
    ));
  }
}
