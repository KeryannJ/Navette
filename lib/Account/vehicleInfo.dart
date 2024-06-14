import 'package:flutter/material.dart';

/// information sur le véhicule de l'utilisateur
class VehicleInfo extends StatelessWidget {
  const VehicleInfo(
      {super.key,
      required this.modele,
      required this.couleur,
      required this.plaque});
  final String modele;
  final String couleur;
  final String plaque;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: 310,
        width: 500,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.car_repair),
              Text(
                "Informations du véhicule",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: TextEditingController(text: modele),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Modèle',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: TextEditingController(text: couleur),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Couleur',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: TextEditingController(text: plaque),
                  decoration: const InputDecoration(
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
