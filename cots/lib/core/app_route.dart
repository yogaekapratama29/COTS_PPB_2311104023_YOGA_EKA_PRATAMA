import 'package:cots/presentation/pages/daftar_sensor.dart';
import 'package:cots/presentation/pages/detail_sensor.dart';
import 'package:cots/presentation/pages/monitoring_sensor.dart';
import 'package:cots/presentation/pages/riwayat_data.dart';
import 'package:cots/presentation/pages/tambah_sensor.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String monitoring = '/';
  static const String sensorList = '/sensor-list';
  static const String sensorDetail = '/sensor-detail';
  static const String history = '/history';
  static const String addSensor = '/add-sensor';

  static Map<String, WidgetBuilder> routes = {
    monitoring: (context) => const MonitoringSensor(),
    sensorList: (context) => const DaftarSensor(),
    history: (context) => const RiwayatData(),
    addSensor: (context) => const TambahSensor(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case monitoring:
        return MaterialPageRoute(builder: (_) => const MonitoringSensor());
      case sensorList:
        return MaterialPageRoute(builder: (_) => const DaftarSensor());
      case sensorDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DetailSensor(sensorId: args?['sensorId']),
        );
      case history:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => RiwayatData(sensorId: args?['sensorId']),
        );
      case addSensor:
        return MaterialPageRoute(builder: (_) => const TambahSensor());
      default:
        return null;
    }
  }

  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndRemoveUntil(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false, arguments: arguments);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}