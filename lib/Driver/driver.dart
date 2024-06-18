import 'dart:async';
import 'dart:convert';
import 'package:navette/Helpers/CityHelper.dart';
import 'package:navette/Helpers/PreferenceHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:navette/Helpers/TravelHelper.dart';

/// Page permettant de commencer / finir trajet
class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => MapSampleState();
}

class MapSampleState extends State<Driver> {
  // Controller de la map
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  // Coordonnées du trajet
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  // position actuelle de l'utilisateur
  late LocationData currentPosition;
  late Location location;
  // Marqueur sur la map représentant les points de passages
  Set<Marker> markers = {};
  // Icone de l'utilisateur
  Set<Circle> userCircle = {};
  bool _isUserLocationAvailable = false;
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(49.892208, 2.298158),
    zoom: 16,
  );
  // trajet en cours ( départ et arrivée )
  late List<int> currentTravel;
  int numberOfPassenger = 0;

  @override
  void initState() {
    super.initState();
    location = Location();
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.getLocation().then((value) => currentPosition = value);
        location.onLocationChanged.listen((LocationData position) async {
          if (mounted) {
            _isUserLocationAvailable = true;
            goToUserLocation();
            updateCircle(position);
            if (CityHelper.travelOngoing) {
              var prevNumberOfPassenger = numberOfPassenger;
              numberOfPassenger = await TravelHelper.getNumberOfPassenger();
              if (prevNumberOfPassenger != numberOfPassenger) {
                showCustomDialog(
                    context, prevNumberOfPassenger < numberOfPassenger);
              }
              await prepareRouteCreation(currentTravel);
            }
            setState(() {
              currentPosition = position;
              _kGooglePlex = CameraPosition(
                target: LatLng(
                    currentPosition.latitude!, currentPosition.longitude!),
                zoom: 16,
              );
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        circles: userCircle,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          if (_isUserLocationAvailable) {
            goToUserLocation();
          }
        },
        markers: markers,
        polylines: Set<Polyline>.of(polylines.values),
      ),
      Positioned(
        bottom: 20,
        left: MediaQuery.of(context).size.width / 2 - 85,
        child: CityHelper.travelOngoing
            ? FloatingActionButton.extended(
                label: const Text('Finir le trajet'),
                icon: const Icon(Icons.drive_eta),
                onPressed: () async {
                  if (!CityHelper.travelOngoing) {
                    const snackBar = SnackBar(
                      content: Text(
                          'Impossible d\'arrêter un trajet n\'ayant pas débuté'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  CityHelper.travelOngoing = false;
                  if (await endOrStartTravel(false, [])) {
                    PreferenceHelper.setBoolValue(
                        PreferenceHelper.isDrivingKey, false);
                    setState(() {
                      polylines.clear;
                      polylineCoordinates.clear();
                      markers.clear();
                      currentTravel.clear();
                    });
                  } else {
                    CityHelper.travelOngoing = true;
                    const snackBar = SnackBar(
                      content: Text(
                          'Erreur lors de l\'arrêt du trajet veuillez réessayer'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                })
            : FloatingActionButton.extended(
                label: const Text('Démarrer un trajet'),
                icon: const Icon(Icons.drive_eta),
                onPressed: () async {
                  if (CityHelper.travelOngoing) {
                    const snackBar = SnackBar(
                      content: Text(
                          'Trajet en cours de création veuillez patienter'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  var availableStop = CityHelper.getAvailableTravel();
                  if (availableStop.isEmpty) {
                    const snackBar = SnackBar(
                      content: Text(
                          'Veuillez nous excuser mais le service n\'est pas disponible pour le moment, revenez plus tard'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    CityHelper.travelOngoing = true;
                    if (await endOrStartTravel(true, availableStop)) {
                      PreferenceHelper.setBoolValue(
                          PreferenceHelper.isDrivingKey, true);
                      prepareRouteCreation(availableStop);
                      currentTravel = availableStop;
                    } else {
                      CityHelper.travelOngoing = false;
                      const snackBar = SnackBar(
                        content: Text(
                            'Erreur lors de la création du trajet veuillez réessayer'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                }),
      ),
      CityHelper.travelOngoing
          ? Positioned(
              left: 30,
              bottom: 30,
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 30.0,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$numberOfPassenger',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    ]);
  }

  Future<void> prepareRouteCreation(List<int> travel) async {
    polylines.clear;
    polylineCoordinates.clear();
    markers.clear();
    _kGooglePlex = CameraPosition(
      target: LatLng(currentPosition.latitude!, currentPosition.longitude!),
    );
    late Stop aStop;
    late Zone aZone;
    for (var stop in CityHelper.villesDict[travel[0]]!.stops) {
      if (stop.id == travel[1]) {
        aStop = stop;
      }
    }
    for (var zone in CityHelper.villesDict[travel[2]]!.zones) {
      aZone = zone;
    }

    List<String> latLngD = aStop.gps!.split(',');
    LatLng depart =
        LatLng(double.parse(latLngD.first), double.parse(latLngD.last));

    List<String> latLngA = aZone.gps!.split(',');
    LatLng arrivee =
        LatLng(double.parse(latLngA.first), double.parse(latLngA.last));

    await _createPolylines(aStop.gps!, depart.latitude, depart.longitude,
        arrivee.latitude, arrivee.longitude);
  }

  _createPolylines(
    String depart,
    double departLatitude,
    double departLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    var polylinePoints = PolylinePoints();

    markers.clear();
    polylineCoordinates.clear();

    markers.add(Marker(
        markerId: const MarkerId('depart'),
        position: LatLng(departLatitude, departLongitude)));
    markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(destinationLatitude, destinationLongitude)));
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      '', // secret Google Maps
      PointLatLng(currentPosition.latitude!, currentPosition.longitude!),
      PointLatLng(destinationLatitude, destinationLongitude),
      wayPoints: [PolylineWayPoint(location: depart)],
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = const PolylineId('poly');

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    setState(() {
      polylines[id] = polyline;
    });
  }

  void updateCircle(LocationData position) {
    LatLng latLng = LatLng(position.latitude!, position.longitude!);
    userCircle.clear();
    userCircle.add(Circle(
      circleId: const CircleId('userLocationCircle'),
      center: latLng,
      radius: position.accuracy!,
      strokeWidth: 1,
      strokeColor: Colors.red,
      fillColor: const Color.fromARGB(100, 255, 0, 0),
    ));
  }

  Future<void> goToUserLocation() async {
    final GoogleMapController controller = await _controller.future;
    LatLng latLng =
        LatLng(currentPosition.latitude!, currentPosition.longitude!);
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: 16),
    ));
  }

  Future<bool> endOrStartTravel(bool isStart, List<int> travel) async {
    var url = Uri.parse('${PreferenceHelper.navetteApi}api/v1/travel/');
    if (isStart) {
      try {
        http.Response response = await http.post(url,
            headers: {
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer ${PreferenceHelper.bearer}'
            },
            body: jsonEncode({
              'departure': CityHelper.getDeparture(travel[0], travel[1]),
              'arrival': CityHelper.getArrival(travel[2], travel[3]),
              'back_travel': travel[0] == CityHelper.villeA,
              'driver_id': PreferenceHelper.userId,
            }));
        if (response.statusCode == 200) {
          return true;
        }
      } catch (e) {
        print(e);
      }
      return false;
    } else {
      var travelId = -1;
      var urlTravelId = Uri.parse(
          '${PreferenceHelper.navetteApi}api/v1/user/${PreferenceHelper.userId}/current_travel');
      try {
        http.Response response = await http.get(urlTravelId, headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer ${PreferenceHelper.bearer}'
        });
        if (response.statusCode == 200) {
          travelId = jsonDecode(response.body)['id'];
        }
      } catch (e) {
        print(e);
      }
      var url = Uri.parse(
          '${PreferenceHelper.navetteApi}api/v1/travel/$travelId/finish');
      try {
        http.Response response = await http.patch(url, headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer ${PreferenceHelper.bearer}'
        });
        if (response.statusCode == 200) {
          return true;
        }
      } catch (e) {
        print(e);
      }
      return false;
    }
  }

  void showCustomDialog(BuildContext context, bool isPlus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pop(true);
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info,
                size: 50,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              isPlus
                  ? const Text(
                      "Un passager vient de d'entrer dans le véhicule",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    )
                  : const Text(
                      "Un passager vient de sortir du véhicule",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
