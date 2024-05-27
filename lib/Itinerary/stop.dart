import 'package:application/Helpers/CityHelper.dart';
import 'package:flutter/material.dart';

class StopWidget extends StatelessWidget {
  const StopWidget(
      {super.key,
      required this.villeD,
      required this.villeA,
      required this.stop,
      required this.zone,
      required this.nbDriver,
      required this.nbPassenger});
  final int villeD;
  final int villeA;
  final int stop;
  final int zone;
  final int nbDriver;
  final int nbPassenger;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        height: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(children: [
                  Column(
                    children: [
                      CityHelper.getImage(false, true, false, [villeD, stop])
                              .isEmpty
                          ? Image.asset(
                              'assets/logo.png',
                              height: 75,
                              width: 75,
                            )
                          : Image.network(
                              CityHelper.getImage(
                                  true, true, false, [villeD, stop]),
                              height: 75,
                              width: 75,
                            ),
                      Text(CityHelper.getStopNameOfCity(villeD, stop).first),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_circle_right,
                    size: 30,
                  ),
                  Column(
                    children: [
                      CityHelper.getImage(false, false, true, [villeA, zone])
                              .isEmpty
                          ? Image.asset(
                              'assets/logo.png',
                              height: 75,
                              width: 75,
                            )
                          : Image.network(
                              CityHelper.getImage(
                                  false, false, true, [villeA, zone]),
                              height: 75,
                              width: 75,
                            ),
                      Text(CityHelper.getZoneNameOfCity(villeA, zone).first),
                    ],
                  ),
                ]),
                Row(children: [
                  const Icon(Icons.account_circle_outlined),
                  // Todo Trouver un moyen de récupérer le nombre de passager en attente ( beacon du stop ? )
                  Text('$nbPassenger passagers en attente')
                ]),
                Row(children: [
                  const Icon(Icons.directions_car),
                  Text('$nbDriver conducteurs en approche')
                ])
              ]),
        ]));
  }
}
