import 'package:marquee/marquee.dart';
import 'package:navette/Helpers/CityHelper.dart';
import 'package:flutter/material.dart';

class HistoryElement extends StatelessWidget {
  HistoryElement(
      {super.key,
      required this.startTime,
      required this.endTime,
      required this.isAway,
      required this.isDriver,
      required this.villeD,
      required this.villeA,
      required this.stop,
      required this.zone});
  DateTime startTime, endTime;
  bool isDriver, isAway;
  int villeD, villeA, stop, zone;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 190,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isDriver
                ? const Icon(Icons.drive_eta)
                : const Icon(Icons.drive_eta),
            Text(
              '${startTime.day}/0${startTime.month}/${startTime.year}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            CityHelper.getImage(false, true, false, [villeD, stop]).isEmpty
                ? Image.asset(
                    'assets/logo.png',
                    height: 100,
                    width: 100,
                  )
                : Image.network(
                    CityHelper.getImage(false, true, false, [villeD, stop]),
                    height: 100,
                    width: 100,
                  ),
            SizedBox(
              height: 22,
              width: 100,
              child: Marquee(
                text: CityHelper.getStopNameOfCity(villeD, stop).first,
                style: const TextStyle(fontSize: 16),
                scrollAxis: Axis.horizontal,
                blankSpace: 20.0,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
            Text('${startTime.hour}H${startTime.minute}')
          ]),
          const Icon(
            Icons.arrow_circle_right,
            size: 30,
          ),
          Column(children: [
            CityHelper.getImage(false, false, true, [villeA, zone]).isEmpty
                ? Image.asset(
                    'assets/logo.png',
                    height: 100,
                    width: 100,
                  )
                : Image.network(
                    CityHelper.getImage(false, false, true, [villeA, zone]),
                    height: 100,
                    width: 100,
                  ),
            SizedBox(
              height: 22,
              width: 100,
              child: Marquee(
                text: CityHelper.getZoneNameOfCity(villeA, zone).first,
                style: const TextStyle(fontSize: 16),
                scrollAxis: Axis.horizontal,
                blankSpace: 20.0,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
            Text('${endTime.hour}H${endTime.minute}')
          ])
        ]),
      ]),
    );
  }
}
