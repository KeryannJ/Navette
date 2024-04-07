import 'package:application/Common/dropDownMenu.dart';
import 'package:flutter/material.dart';

class ItirenaryInfo extends StatelessWidget {
  const ItirenaryInfo({super.key});

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
        child: Column(children: [
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.map),
            Text(
              "Itinéraire",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(children: [
              Image.asset(
                'assets/logo.png',
                height: 75,
                width: 75,
              ),
              const MyDropDownMenu(items: [
                'Amiens',
                'Creil',
                'Paris',
              ]),
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
              const MyDropDownMenu(items: [
                'Amiens Nord',
                'Amiens Sud',
                'Amiens Centre',
              ]),
            ])
          ]),
        ]));
  }
}
