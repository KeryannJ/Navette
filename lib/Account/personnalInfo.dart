import 'package:flutter/material.dart';

class PersonnalInfo extends StatelessWidget {
  const PersonnalInfo({super.key, required this.name, required this.mail});
  final String name;
  final String mail;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: 210,
        width: 500,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.account_box_rounded),
              Text(
                "Informations personnelles",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: TextEditingController(text: mail),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adresse Mail',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: TextEditingController(text: name),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nom/Prénom',
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
