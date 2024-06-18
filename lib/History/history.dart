import 'package:navette/Common/NoDataPage.dart';
import 'package:navette/Common/loadingPage.dart';
import 'package:navette/Helpers/TravelHelper.dart';
import 'package:navette/History/historyElement.dart';
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
              body: TravelHelper.isHistoryEmpty(isReturn)
                  ? NoDataPage()
                  : ListView.builder(
                      itemCount: TravelHelper.historyList
                          .where((historyElt) => historyElt.isAway == isReturn)
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        var filteredList = TravelHelper.historyList
                            .where(
                                (historyElt) => historyElt.isAway == isReturn)
                            .toList();
                        var historyElt = filteredList[index];
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
