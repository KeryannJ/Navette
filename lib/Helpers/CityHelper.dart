// ignore_for_file: file_names

import 'dart:convert';

import 'package:application/Helpers/PreferenceHelper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class City {
  City(this.id, this.name, this.image, this.stops, this.zones);
  int id;
  String name;
  String? image;
  List<Stop> stops;
  List<Zone> zones;
}

class Zone {
  Zone(this.id, this.name, this.image, this.gps);
  int id;
  String name;
  String? image;
  String? gps;
}

class Stop {
  Stop(this.id, this.name, this.image, this.gps, this.debOuverture,
      this.finOuverture);
  int id;
  String name;
  String? image;
  String? gps;
  DateTime? debOuverture;
  DateTime? finOuverture;
}

class CityHelper {
  static Map<int, City> villesDict = {};
  static int villeD = -1;
  static int villeA = -1;
  static int stop = -1;
  static int zone = -1;
  static bool travelOngoing = false;
  static Future fetchCityAndZoneAndStop() async {
    var format = DateFormat('HH:mm:ss.SSSSS');
    if (PreferenceHelper.navetteApi.isEmpty) {
      print('Clé API Vide');
      return;
    }
    var url = Uri.parse('${PreferenceHelper.navetteApi}api/v1/city/');

    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      // Zone
      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        for (var city in data) {
          var cityUrl = Uri.parse(
              '${PreferenceHelper.navetteApi}api/v1/city/${city['id']}');
          http.Response cityResponse = await http.get(cityUrl, headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'Bearer ${PreferenceHelper.bearer}'
          });
          if (cityResponse.statusCode == 200) {
            var cityData = json.decode(utf8.decode(cityResponse.bodyBytes));
            List<Stop> tmpStops = [];
            List<Zone> tmpZones = [];
            if (cityData['zones'] != null) {
              for (var zone in cityData['zones']) {
                tmpZones.add(Zone(
                  zone['id'],
                  zone['name'],
                  zone['picture'],
                  zone['gps'],
                ));
              }
            }
            if (cityData['stops'] != null) {
              for (var stop in cityData['stops']) {
                DateTime? open, close;
                if (stop['open_at'] != null) {
                  open = format.parse(stop['open_at']);
                }
                if (stop['close_at'] != null) {
                  close = format.parse(stop['close_at']);
                }
                tmpStops.add(
                  Stop(stop['id'], stop['name'], stop['picture'], stop['gps'],
                      open, close),
                );
              }
            }
            City tmpCity = City(cityData['id'], cityData['name'],
                cityData['picture'], tmpStops, tmpZones);
            villesDict.putIfAbsent(tmpCity.id, () => tmpCity);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return;
  }

  static List<String> getZoneNameOfCity(int cityId, int aZoneToPutFirst) {
    if (villesDict.isNotEmpty &&
        villesDict[cityId] != null &&
        villesDict[cityId]!.zones.isNotEmpty) {
      List<String> zoneNames = [];
      for (var zone in villesDict[cityId]!.zones) {
        if (zone.id == aZoneToPutFirst) {
          zoneNames =
              ['${zone.name} ( ${villesDict[cityId]!.name} )'] + zoneNames;
        } else {
          zoneNames.add('${zone.name} ( ${villesDict[cityId]!.name} )');
        }
      }
      return zoneNames;
    }
    return ['Rien '];
  }

  static List<String> getStopNameOfCity(int cityId, int aStopToPutFirst) {
    if (villesDict.isNotEmpty &&
        villesDict[cityId] != null &&
        villesDict[cityId]!.stops.isNotEmpty) {
      List<String> stopNames = [];
      for (var stop in villesDict[cityId]!.stops) {
        if (stop.id == aStopToPutFirst) {
          stopNames =
              ['${stop.name} ( ${villesDict[cityId]!.name} )'] + stopNames;
        } else {
          stopNames.add('${stop.name} ( ${villesDict[cityId]!.name} )');
        }
      }
      return stopNames;
    }
    return ['Rien '];
  }

  static List<String> getCityNames(int aCityToPutFirst) {
    if (villesDict.isNotEmpty) {
      List<String> cityNames = [];
      for (var values in villesDict.entries) {
        if (values.value.id == aCityToPutFirst) {
          cityNames = [values.value.name] + cityNames;
        } else {
          cityNames.add(values.value.name);
        }
      }
      return cityNames;
    }
    return ['Rien '];
  }

  static String getCityName(int cityId) {
    return villesDict[cityId]!.name;
  }

  static String getImage(bool isVille, bool isStop, bool isZone, List<int> id) {
    if (isVille && villesDict[id.first]!.image != null) {
      return villesDict[id.first]!.image!;
    }
    if (isStop && villesDict[id.first]!.stops.isNotEmpty) {
      for (var stop in villesDict[id.first]!.stops) {
        if (stop.id == id.last) {
          return stop.image != null ? stop.image! : '';
        }
      }
    }
    if (isZone && villesDict[id.first]!.zones.isNotEmpty) {
      for (var zone in villesDict[id.first]!.zones) {
        if (zone.id == id.last) {
          return zone.image != null ? zone.image! : '';
        }
      }
    }
    return '';
  }

  static Future getUserItirenaryInfo() async {
    var url = Uri.parse(
        '${PreferenceHelper.navetteApi}api/v1/user/${PreferenceHelper.userId}');

    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${PreferenceHelper.bearer}'
      });
      if (response.statusCode == 200) {
        var selectedUserData = json.decode(response.body);
        CityHelper.villeD = selectedUserData['city']['id'];
        CityHelper.zone = selectedUserData['zone']['id'];
        CityHelper.stop = selectedUserData['stop']['id'];
        CityHelper.villeA = 1;
      }
    } catch (e) {
      print(e);
    }
  }

  static int getDeparture(int ville, int s) {
    return (ville * 100) + s;
  }

  static int getArrival(int ville, int z) {
    return (ville * 100) + z;
  }

  static List<int> getAvailableTravel() {
    DateTime current = DateTime.now();
    if ((villesDict[villeD]!.stops.first.debOuverture != null) &&
        (villesDict[villeD]!.stops.first.finOuverture != null) &&
        (current.isAfter(villesDict[villeD]!.stops.first.debOuverture!)) &&
        (current.isBefore(villesDict[villeD]!.stops.first.finOuverture!))) {
      return [villeD, villesDict[villeD]!.stops.first.id, villeA, zone];
    }
    if ((villesDict[villeA]!.stops[stop - 1].debOuverture != null) &&
        (villesDict[villeA]!.stops[stop - 1].finOuverture != null) &&
        (current.isAfter(villesDict[villeA]!.stops[stop - 1].debOuverture!)) &&
        (current.isBefore(villesDict[villeA]!.stops[stop - 1].finOuverture!))) {
      return [villeA, stop, villeD, villesDict[villeD]!.zones.first.id];
    }
    return [];
  }

}
