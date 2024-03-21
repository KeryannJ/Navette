import 'package:flutter/material.dart';

class HistoryElement extends StatelessWidget {
  const HistoryElement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.drive_eta),
            Text(
              'Date/heure',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            Image.asset(
              'assets/logo.png',
              height: 75,
              width: 75,
            ),
            const Text('Ville de départ')
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
            const Text('Zone d' 'arrivée'),
          ])
        ]),
      ]),
    );
  }
}
