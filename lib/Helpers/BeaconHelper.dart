import 'dart:convert';
import 'package:application/Helpers/CityHelper.dart';
import 'package:application/Helpers/PreferenceHelper.dart';
import 'package:application/Helpers/TravelHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;

class BeaconHelper {
  static bool isStop = false;
  static bool isInCar = false;
  static Map<int, String> userBeaconMacAddressDict = {};
  static int currentDriver = -1;
  static List<int> currentStop = [];

  static Future<String> startScan() async {
    List<ScanResult> currentResults = [];
    var notifText = '';
    FlutterBluePlus.scanResults.listen((results) {
      if (results.isNotEmpty) {
        currentResults.addAll(results);
      }
    });
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
    var found = false;
    if (currentResults.isNotEmpty) {
      for (ScanResult result in currentResults) {
        // on le remonte car on va forcément y passer vu que c'est la condition
        // la plus importante
        var driver = getDriverIdFromAddress(result.device.remoteId.toString());
        if (!isInCar && !isStop) {
          if (driver != -1) {
            isInCar = true;
            TravelHelper.addUserToTravel(driver);
            found = true;
            // on ne continue pas car 2 driver = pas possible et un on s'en fout
            // car l'user vient de monter
            var travel = CityHelper.getAvailableTravel();
            notifText =
                'Début du trajet à destination de ${CityHelper.getZoneNameOfCity(travel[2], travel[3]).first}';
            break;
          }
          var stop =
              CityHelper.isAddressInStops(result.device.remoteId.toString());
          if (stop.isNotEmpty && !found) {
            if (stop != currentStop) {
              CityHelper.changeStopCounter(true, stop);
              currentStop = stop;
              isStop = true;
              notifText =
                  'En attente au stop ${CityHelper.getStopNameOfCity(currentStop.first, currentStop.last).first}';
            }
            found = true;
            continue;
          }
        }
        if (isInCar && driver != -1 && currentDriver == driver) {
          found = true;
          break;
        }
        if (isStop) {
          if (driver != -1) {
            isInCar = true;
            isStop = false;
            TravelHelper.addUserToTravel(driver);
            CityHelper.changeStopCounter(false, currentStop);
            currentStop = [];
            found = true;
            var travel = CityHelper.getAvailableTravel();
            notifText =
                'Début du trajet à destination de ${CityHelper.getZoneNameOfCity(travel[2], travel[3]).first}';
          }
          var stop =
              CityHelper.isAddressInStops(result.device.remoteId.toString());
          if (stop.isNotEmpty &&
              currentStop.first == stop.first &&
              currentStop.last == stop.last) {
            found = true;
            continue;
          }
        }
      }
      if (isInCar && !found) {
        TravelHelper.removeUserFromTravel();
        isInCar = false;
        notifText = 'Fin du trajet';
      }
      if (currentStop.isNotEmpty && isStop && !found) {
        CityHelper.changeStopCounter(false, currentStop);
        currentStop = [];
        isStop = false;
      }
    }
    return notifText;
  }

  static int getDriverIdFromAddress(String beacon) {
    for (var user in userBeaconMacAddressDict.entries) {
      if (user.value == beacon) {
        return user.key;
      }
    }
    return -1;
  }

  static Future<void> fetchUserBeacon() async {
    var url = Uri.parse('${PreferenceHelper.navetteApi}api/v1/user/');
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        for (var data in jsonData) {
          if (data['mac_beacon'] != null) {
            userBeaconMacAddressDict.putIfAbsent(
                data['id'], () => data['mac_beacon']);
          }
        }
      } else {
        throw ErrorDescription(
            ' Erreur de récupération code d\'erreur = ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
