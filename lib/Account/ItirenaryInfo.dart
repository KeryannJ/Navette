import 'package:application/Common/dropDownMenu.dart';
import 'package:application/Helpers/CityHelper.dart';
import 'package:flutter/material.dart';

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
      height: 400,
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
        const Text('Aller :'),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            CityHelper.getImage(false, true, false, [widget.city, widget.stop])
                    .isEmpty
                ? Image.asset(
                    'assets/logo.png',
                    height: 75,
                    width: 75,
                  )
                : Image.network(
                    CityHelper.getImage(
                        false, true, false, [widget.city, widget.stop]),
                    height: 75,
                    width: 75,
                  ),
            Text(CityHelper.getStopNameOfCity(widget.city, 0).first)
          ]),
          const Icon(
            Icons.arrow_circle_right,
            size: 30,
          ),
          Column(children: [
            CityHelper.getImage(false, false, true, [widget.city, widget.zone])
                    .isEmpty
                ? Image.asset(
                    'assets/logo.png',
                    height: 75,
                    width: 75,
                  )
                : Image.network(
                    CityHelper.getImage(
                        false, false, true, [widget.city, widget.zone]),
                    height: 75,
                    width: 75,
                  ),
            MyDropDownMenu(
                items: CityHelper.getZoneNameOfCity(destCity, widget.zone)),
          ])
        ]),
        const Text('Retour :'),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            CityHelper.getImage(true, false, false, [widget.city]).isEmpty
                ? Image.asset(
                    'assets/logo.png',
                    height: 75,
                    width: 75,
                  )
                : Image.network(
                    CityHelper.getImage(true, false, false, [widget.city]),
                    height: 75,
                    width: 75,
                  ),
            Text(CityHelper.getCityName(widget.city)),
          ]),
          const Icon(
            Icons.arrow_circle_left,
            size: 30,
          ),
          Column(children: [
            CityHelper.getImage(false, true, false, [destCity, widget.stop])
                    .isEmpty
                ? Image.asset(
                    'assets/logo.png',
                    height: 75,
                    width: 75,
                  )
                : Image.network(
                    CityHelper.getImage(
                        false, true, false, [widget.city, widget.stop]),
                    height: 75,
                    width: 75,
                  ),
            MyDropDownMenu(
              items: CityHelper.getStopNameOfCity(destCity, 1),
            ),
          ])
        ]),
      ]),
    );
  }
}
