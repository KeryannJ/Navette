import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:navette/Helpers/CityHelper.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

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
        height: 260,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RatingBarIndicator(
                  rating: 1.0,
                  itemBuilder: (context, index) => const Icon(
                    Icons.directions_car,
                    color: Colors.blue,
                  ),
                  itemCount: 5,
                  itemSize: 25.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            Row(children: [
              Column(
                children: [
                  CityHelper.getImage(false, true, false, [villeD, stop])
                          .isEmpty
                      ? Image.asset(
                          'assets/logo.png',
                          height: 115,
                          width: 115,
                        )
                      : Image.network(
                          CityHelper.getImage(
                              false, true, false, [villeD, stop]),
                          height: 115,
                          width: 115,
                        ),
                  SizedBox(
                    height: 40,
                    width: 135,
                    child: Marquee(
                      text: CityHelper.getStopNameOfCity(villeD, stop).first,
                      style: const TextStyle(fontSize: 16),
                      scrollAxis: Axis.horizontal,
                      blankSpace: 30.0,
                      velocity: 50.0,
                      pauseAfterRound: const Duration(seconds: 1),
                      startPadding: 10.0,
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.arrow_circle_right,
                  size: 30,
                ),
              ),
              Column(
                children: [
                  CityHelper.getImage(false, false, true, [villeA, zone])
                          .isEmpty
                      ? Image.asset(
                          'assets/logo.png',
                          height: 115,
                          width: 115,
                        )
                      : Image.network(
                          CityHelper.getImage(
                              false, false, true, [villeA, zone]),
                          height: 115,
                          width: 115,
                        ),
                  SizedBox(
                    height: 40,
                    width: 135,
                    child: Marquee(
                      text: CityHelper.getZoneNameOfCity(villeA, zone).first,
                      style: const TextStyle(fontSize: 16),
                      scrollAxis: Axis.horizontal,
                      blankSpace: 30.0,
                      velocity: 50.0,
                      pauseAfterRound: const Duration(seconds: 1),
                      startPadding: 10.0,
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
                ],
              ),
            ]),
            Row(children: [
              const Icon(Icons.account_circle_outlined),
              Text(
                '$nbPassenger passagers en attente',
                style: const TextStyle(fontSize: 16),
              )
            ]),
            Row(children: [
              const Icon(Icons.directions_car),
              Text(
                '$nbDriver conducteurs en route',
                style: const TextStyle(fontSize: 16),
              )
            ])
          ]),
        ]));
  }
}
