import 'dart:convert';

import 'package:application/Helpers/PreferenceHelper.dart';
import 'package:http/http.dart' as http;

class Travel {
  Travel(this.villeD, this.villeA, this.stop, this.zone, this.driverCount,
      this.passengerCount);
  int villeD;
  int villeA;
  int stop;
  int zone;
  int driverCount;
  int passengerCount;

  void addOneDriver() {
    driverCount++;
  }
}

class TravelHelper {
  static Map<int, Travel> travels = {};
  static Future<bool> fetchTravel() async {
    var url = Uri.parse(
        '${PreferenceHelper.navetteApi}api/v1/travel/?back_travel=true&outgoing_travel=true&is_finished=false');
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      if (response.statusCode == 200) {
        travels.clear();
        var data = json.decode(utf8.decode(response.bodyBytes));
        for (var trav in data) {
          if (trav['departure'] != null && trav['arrival'] != null) {
            var villeAndStop = decodeTravelId(trav['departure']);
            var villeAndZone = decodeTravelId(trav['arrival']);
            var id = int.parse('${trav['departure']}${trav['arrival']}');
            if (villeAndStop.isEmpty && villeAndZone.isEmpty) {
              continue;
            }
            travels.putIfAbsent(
                id,
                () => Travel(villeAndStop.first, villeAndStop.last,
                    villeAndZone.first, villeAndZone.last, 0, 0));

            if (travels.containsKey(id)) {
              travels[id]!.addOneDriver();
            }
          }
        }
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}

List<int> decodeTravelId(int travelId) {
  if (travelId > 99) {
    return [travelId ~/ 100, (travelId - ((travelId ~/ 100) * 100))];
  }
  return [];
}
