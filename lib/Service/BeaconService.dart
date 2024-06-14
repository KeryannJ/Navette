import 'dart:async';
import 'dart:ui';
import 'package:navette/Helpers/BeaconHelper.dart';
import 'package:navette/Helpers/CityHelper.dart';
import 'package:navette/Helpers/PreferenceHelper.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
class BeaconService {
  @pragma('vm:entry-point')
  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'navette',
      'Navette',
      channelDescription: 'Informations sur le service',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'Navette',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      19,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @pragma('vm:entry-point')
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
        iosConfiguration: IosConfiguration(),
        androidConfiguration: AndroidConfiguration(
            onStart: onStart,
            isForegroundMode: true,
            autoStart: true,
            initialNotificationContent:
                'Le service détecte les arrêts / conducteurs aux alentours',
            initialNotificationTitle: 'Navette'));
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_bg_service_small');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    await PreferenceHelper.init();
    await CityHelper.fetchCityAndZoneAndStop();
    await CityHelper.getUserItirenaryInfo();
    await BeaconHelper.fetchUserBeacon();
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });

      service.on('stopService').listen((event) {
        service.stopSelf();
      });
    }

    Timer.periodic(const Duration(seconds: 20), (timer) async {
      await PreferenceHelper.init();
      var isDriving = await PreferenceHelper.getDrivingState();
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          if (isDriving) {
          } else {}
        }
      }
      if (!isDriving) {
        var notification = await BeaconHelper.startScan();
        if (notification.isNotEmpty) {
          _showNotification('Navette', notification);
        }
        service.invoke('update');
      }
    });
  }
}
