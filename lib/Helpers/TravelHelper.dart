import 'dart:convert';

import 'package:application/Helpers/CityHelper.dart';
import 'package:application/Helpers/PreferenceHelper.dart';
import 'package:application/History/history.dart';
import 'package:flutter/material.dart';
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

class History {
  History(this.dateHeureDeb, this.dateHeureFin, this.isDriver, this.villeD,
      this.villeA, this.stop, this.zone, this.isAway);
  DateTime dateHeureDeb;
  DateTime dateHeureFin;
  bool isDriver;
  int villeD;
  int villeA;
  int stop;
  int zone;
  bool isAway;
}

class TravelHelper {
  static Map<int, Travel> travels = {};
  static List<History> historyList = [];
  static int currentTravel = -1;
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
            if (travels.containsKey(id)) {
              travels[id]!.addOneDriver();
            } else {
              var nbpassager =
                  await CityHelper.getPassengerOfStop(villeAndStop);
              travels.putIfAbsent(
                  id,
                  () => Travel(villeAndStop.first, villeAndStop.last,
                      villeAndZone.first, villeAndZone.last, 0, nbpassager));
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

  static List<int> decodeTravelId(int travelId) {
    if (travelId > 99) {
      return [travelId ~/ 100, (travelId - ((travelId ~/ 100) * 100))];
    }
    return [];
  }

  static Future<bool> fetchHistory() async {
    var url = Uri.parse(
        '${PreferenceHelper.navetteApi}api/v1/user/${PreferenceHelper.userId}/history?back_travel=true&outgoing_travel=true&is_finished=true');
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      if (response.statusCode == 200) {
        historyList.clear();
        var data = json.decode(utf8.decode(response.bodyBytes));
        for (var historyElt in data) {
          if (historyElt['departure'] != null &&
              historyElt['arrival'] != null) {
            var villeAndStop = decodeTravelId(historyElt['departure']);
            var villeAndZone = decodeTravelId(historyElt['arrival']);
            if (villeAndStop.isEmpty && villeAndZone.isEmpty) {
              continue;
            }
            historyList.add(History(
                DateTime.parse(historyElt['started_at']),
                DateTime.parse(historyElt['finished_at']),
                historyElt['is_driver'],
                villeAndStop.first,
                villeAndStop.last,
                villeAndZone.first,
                villeAndZone.last,
                historyElt['back_travel']));
          }
        }
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<void> addUserToTravel(int driverId) async {
    var urlTravelId = Uri.parse(
        '${PreferenceHelper.navetteApi}api/v1/user/${PreferenceHelper.userId}/current_travel');
    try {
      http.Response response = await http.post(urlTravelId, headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      if (response.statusCode == 200) {
        currentTravel = jsonDecode(response.body)['id'];
      }
    } catch (e) {
      print(e);
    }
    var url = Uri.parse(
        '${PreferenceHelper.navetteApi}/api/v1/travel/$currentTravel/add-user/${PreferenceHelper.userId}');
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      throw ErrorDescription(
          ' Erreur de récupération code d\'erreur = ${response.statusCode}');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> removeUserFromTravel() async {
    var url = Uri.parse(
        '${PreferenceHelper.navetteApi}/api/v1/travel/$currentTravel/remove-user/${PreferenceHelper.userId}');
    try {
      http.Response response = await http.delete(url, headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      throw ErrorDescription(
          ' Erreur de récupération code d\'erreur = ${response.statusCode}');
    } catch (e) {
      print(e);
    }
  }
}
