import 'package:application/Common/dropDownMenu.dart';
import 'package:flutter/material.dart';

class PersonnalInfo extends StatelessWidget {
  const PersonnalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        height: 150,
        width: 500,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: const Column(
          children: [
            Text("Informations personnelles"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Adresse mail"),
                MyDropDownMenu(items: [
                  'Martin@gmail.com',
                  'Mamadou@gmail.com',
                  'Tanguy@gmail.com',
                  'Keryann@gmail.com'
                ])
              ],
            ),
            Row(
              children: [
                Text("Nom/Prénom"),
              ],
            )
          ],
        ));
  }
}
