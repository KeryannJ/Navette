import 'package:application/Itinerary/stop.dart';
import 'package:flutter/material.dart';

class Itineraire extends StatelessWidget {
  const Itineraire({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      const Text(
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          'Départ'),
      ListView(
        shrinkWrap: true,
        children: const [Stop()],
      ),
      const Text(
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          'Arrivée'),
      Expanded(
          child: ListView(
        children: const [Stop(), Stop(), Stop(), Stop(), Stop(), Stop()],
      )),
    ]);
  }
}
