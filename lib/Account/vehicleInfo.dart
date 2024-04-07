import 'package:flutter/material.dart';

class VehicleInfo extends StatelessWidget {
  const VehicleInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: 300,
        width: 500,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.car_repair),
              Text(
                "Informations du véhicule",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ]),
            Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Modèle',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Couleur',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Plaque',
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
