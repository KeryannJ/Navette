import 'package:navette/Common/dropDownMenu.dart';
import 'package:navette/Helpers/CityHelper.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

/// Page des itinéraires utilisateur ( aller / retour )
class ItirenaryInfo extends StatefulWidget {
  const ItirenaryInfo(
      {super.key, required this.city, required this.zone, required this.stop});
  final int city;
  final int zone;
  final int stop;

  @override
  State<ItirenaryInfo> createState() => _ItirenaryInfo();
}

class _ItirenaryInfo extends State<ItirenaryInfo> {
  int destCity = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      height: 410,
      width: 500,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(children: [
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.map),
          Text(
            "Itinéraire",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ]),
        const Text('Aller :',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            height: 150,
            width: 140,
            child: Column(children: [
              CityHelper.getImage(
                      false, true, false, [widget.city, widget.stop]).isEmpty
                  ? Image.asset(
                      'assets/logo.png',
                      height: 100,
                      width: 100,
                    )
                  : Image.network(
                      CityHelper.getImage(
                          false, true, false, [widget.city, widget.stop]),
                      height: 100,
                      width: 100,
                    ),
              SizedBox(
                height: 40,
                width: 100,
                child: Marquee(
                  text: CityHelper.getStopNameOfCity(widget.city, 0).first,
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
            ]),
          ),
          const Icon(
            Icons.arrow_circle_right,
            size: 30,
          ),
          SizedBox(
            height: 150,
            width: 140,
            child: Column(children: [
              CityHelper.getImage(
                      false, false, true, [widget.city, widget.zone]).isEmpty
                  ? Image.asset(
                      'assets/logo.png',
                      height: 100,
                      width: 100,
                    )
                  : Image.network(
                      CityHelper.getImage(
                          false, false, true, [widget.city, widget.zone]),
                      height: 100,
                      width: 100,
                    ),
              MyDropDownMenu(
                  items: CityHelper.getZoneNameOfCity(destCity, widget.zone)),
            ]),
          )
        ]),
        const Text(
          'Retour :',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            height: 150,
            width: 140,
            child: Column(children: [
              CityHelper.getImage(true, false, false, [widget.city]).isEmpty
                  ? Image.asset(
                      'assets/logo.png',
                      height: 100,
                      width: 100,
                    )
                  : Image.network(
                      CityHelper.getImage(true, false, false, [widget.city]),
                      height: 100,
                      width: 100,
                    ),
              SizedBox(
                height: 40,
                width: 100,
                child: Marquee(
                  text: CityHelper.getCityName(widget.city),
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
            ]),
          ),
          const Icon(
            Icons.arrow_circle_left,
            size: 30,
          ),
          SizedBox(
            height: 150,
            width: 140,
            child: Column(children: [
              CityHelper.getImage(false, true, false, [destCity, widget.stop])
                      .isEmpty
                  ? Image.asset(
                      'assets/logo.png',
                      height: 100,
                      width: 100,
                    )
                  : Image.network(
                      CityHelper.getImage(
                          false, true, false, [widget.city, widget.stop]),
                      height: 100,
                      width: 100,
                    ),
              MyDropDownMenu(
                items: CityHelper.getStopNameOfCity(destCity, 1),
              ),
            ]),
          ),
        ]),
      ]),
    );
  }
}
// TODO gérer le onchange