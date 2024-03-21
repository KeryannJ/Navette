import 'package:flutter/material.dart';

class Stop extends StatelessWidget {
  const Stop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        height: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: const Row(children: [
          Image(image: AssetImage('assets/logo.png'), fit: BoxFit.fitHeight),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Description de la ville'),
                Row(children: [
                  Icon(Icons.account_circle_outlined),
                  Text('N passagers en attente')
                ]),
                Row(children: [
                  Icon(Icons.directions_car),
                  Text('N conducteurs en approche')
                ])
              ]),
        ]));
  }
}
