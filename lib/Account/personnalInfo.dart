import 'package:application/Common/dropDownMenu.dart';
import 'package:flutter/material.dart';

class PersonnalInfo extends StatelessWidget {
  const PersonnalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: 180,
        width: 500,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.account_box_rounded),
              Text(
                "Informations personnelles",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Adresse mail",
                  style: TextStyle(fontSize: 16),
                ),
                MyDropDownMenu(items: [
                  'Martin@gmail.com',
                  'Mamadou@gmail.com',
                  'Tanguy@gmail.com',
                  'Keryann@gmail.com'
                ])
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nom/Prénom",
                  style: TextStyle(fontSize: 16),
                ),
                MyDropDownMenu(
                    items: ['Martin', 'Mamadou', 'Tanguy', 'Keryann'])
              ],
            )
          ],
        ));
  }
}
