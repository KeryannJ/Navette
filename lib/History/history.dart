import 'package:application/Common/loadingPage.dart';
import 'package:application/Helpers/TravelHelper.dart';
import 'package:application/History/historyElement.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> {
  bool isReturn = false;
  int selectedIndex = 0;
  void onChange(int value) {
    if (value == 0) {
      isReturn = false;
    } else {
      isReturn = true;
    }
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TravelHelper.fetchHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: ListView.builder(
                itemCount: TravelHelper.historyList.length,
                itemBuilder: (context, index) {
                  var historyElt = TravelHelper.historyList[index];
                  if (historyElt.isAway == isReturn) {
                    return HistoryElement(
                      startTime: historyElt.dateHeureDeb,
                      endTime: historyElt.dateHeureFin,
                      isAway: historyElt.isAway,
                      isDriver: historyElt.isDriver,
                      villeD: historyElt.villeD,
                      villeA: historyElt.villeA,
                      stop: historyElt.stop,
                      zone: historyElt.zone,
                    );
                  }
                },
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: selectedIndex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.business), label: 'Aller'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.house), label: 'Retour')
                ],
                onTap: (value) => onChange(value),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('Circuler y\'a rien à voir');
          } else {
            return const LoadingPage();
          }
        });
  }
}
