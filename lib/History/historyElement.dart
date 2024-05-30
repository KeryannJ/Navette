import 'package:application/Helpers/CityHelper.dart';
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
      height: 180,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(children: [
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
                    height: 90,
                    width: 90,
                  )
                : Image.network(
                    CityHelper.getImage(false, true, false, [villeD, stop]),
                    height: 90,
                    width: 90,
                  ),
            Text(CityHelper.getStopNameOfCity(villeD, stop).first),
            Text('${startTime.hour}H${startTime.hour}')
          ]),
          const Icon(
            Icons.arrow_circle_right,
            size: 30,
          ),
          Column(children: [
            CityHelper.getImage(false, false, true, [villeA, zone]).isEmpty
                ? Image.asset(
                    'assets/logo.png',
                    height: 90,
                    width: 90,
                  )
                : Image.network(
                    CityHelper.getImage(false, false, true, [villeA, zone]),
                    height: 90,
                    width: 90,
                  ),
            Text(CityHelper.getZoneNameOfCity(villeA, zone).first),
            Text('${endTime.hour}H${endTime.hour}')
          ])
        ]),
      ]),
    );
  }
}
