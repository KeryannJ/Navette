import 'package:application/Common/loadingPage.dart';
import 'package:application/Helpers/CityHelper.dart';
import 'package:application/Helpers/TravelHelper.dart';
import 'package:application/Itinerary/stop.dart';
import 'package:flutter/material.dart';

class Itineraire extends StatefulWidget {
  const Itineraire({super.key});
  @override
  State<Itineraire> createState() => ItineraireState();
}

class ItineraireState extends State<Itineraire> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TravelHelper.fetchTravel(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    'Trajet en cours'),
                Expanded(
                    child: ListView.builder(
                  itemCount: TravelHelper.travels.length,
                  itemBuilder: (context, index) {
                    var travel = TravelHelper.travels.entries.elementAt(index);
                    return StopWidget(
                      villeD: travel.value.villeD,
                      villeA: travel.value.villeA,
                      stop: travel.value.stop,
                      zone: travel.value.zone,
                      nbDriver: travel.value.driverCount,
                      nbPassenger: 20,
                    );
                  },
                )),
              ]);
        } else if (snapshot.hasError) {
          return const Text('Aucun trajet disponible');
        } else {
          return const LoadingPage();
        }
      },
    );
  }
}
