import 'dart:async';
import 'dart:convert';
import 'package:application/Helpers/CityHelper.dart';
import 'package:application/Helpers/PreferenceHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => MapSampleState();
}

class MapSampleState extends State<Driver> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  late LocationData currentPosition;
  late Location location;
  Set<Marker> markers = {};
  Set<Circle> userCircle = {};
  bool _isUserLocationAvailable = false;
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(49.892208, 2.298158),
    zoom: 16,
  );
  late List<int> currenTravel;

  @override
  void initState() {
    super.initState();
    location = Location();
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.getLocation().then((value) => currentPosition = value);
        location.onLocationChanged.listen((LocationData position) {
          if (mounted) {
            setState(() {
              currentPosition = position;
              _kGooglePlex = CameraPosition(
                target: LatLng(
                    currentPosition.latitude!, currentPosition.longitude!),
                zoom: 16,
              );
              _isUserLocationAvailable = true;
              goToUserLocation();
              updateCircle(position);
              if (CityHelper.travelOngoing) {
                prepareRouteCreation(currenTravel);
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
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
      floatingActionButton: CityHelper.travelOngoing
          ? FloatingActionButton.extended(
              label: const Text('Finir le trajet'),
              icon: const Icon(Icons.drive_eta),
              onPressed: () async {
                await endOrStartTravel(false, []);
                setState(() {
                  CityHelper.travelOngoing = false;
                  polylines.clear;
                  polylineCoordinates.clear();
                  markers.clear();
                  currenTravel.clear();
                });
              })
          : FloatingActionButton.extended(
              label: const Text('Démarrer un trajet'),
              icon: const Icon(Icons.drive_eta),
              onPressed: () async {
                var availableStop = CityHelper.getAvailableTravel();
                if (availableStop.isEmpty) {
                  const snackBar = SnackBar(
                    content: Text(
                        'Veuillez nous excuser mais le service n\'est pas disponible pour le moment, revenez plus tard'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  await endOrStartTravel(true, availableStop);
                  await prepareRouteCreation(availableStop);
                  currenTravel = availableStop;
                  CityHelper.travelOngoing = true;
                }
              }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> prepareRouteCreation(List<int> travel) async {
    polylines.clear;
    polylineCoordinates.clear();
    markers.clear();
    _kGooglePlex = CameraPosition(
      target: LatLng(currentPosition.latitude!, currentPosition.longitude!),
    );
    List<String> latLngD =
        CityHelper.villesDict[travel[0]]!.stops[travel[1] - 1].gps!.split(',');
    LatLng depart =
        LatLng(double.parse(latLngD.first), double.parse(latLngD.last));

    List<String> latLngA =
        CityHelper.villesDict[travel[2]]!.zones[travel[3] - 1].gps!.split(',');
    LatLng arrivee =
        LatLng(double.parse(latLngA.first), double.parse(latLngA.last));

    await _createPolylines(
        CityHelper.villesDict[travel[0]]!.stops[travel[1] - 1].gps!,
        depart.latitude,
        depart.longitude,
        arrivee.latitude,
        arrivee.longitude);
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

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = const PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
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
      fillColor: Color.fromARGB(100, 255, 0, 0),
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

  Future<void> endOrStartTravel(bool isStart, List<int> travel) async {
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
          print('test');
        }
      } catch (e) {
        print(e);
      }
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
          print('fini');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
