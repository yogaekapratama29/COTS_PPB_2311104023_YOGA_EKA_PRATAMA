import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cots/config/providers.dart';
import 'package:cots/design_system/appColors.dart';
import 'package:cots/design_system/typography.dart';
import 'package:cots/presentation/pages/monitoring_sensor.dart';
import 'package:cots/presentation/pages/daftar_sensor.dart';
import 'package:cots/presentation/pages/detail_sensor.dart';
import 'package:cots/presentation/pages/riwayat_data.dart';
import 'package:cots/presentation/pages/tambah_sensor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ochtjpoudseampekbfsc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9jaHRqcG91ZHNlYW1wZWtiZnNjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI5MDcwODAsImV4cCI6MjA3ODQ4MzA4MH0.PM7qC7BwYVPiJtneXIB9nsCiGSnB8N_V7idHOBLhwMg',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SensorProvider()..loadFromSupabase(),
        ),
      ],
      child: MaterialApp(
        title: 'Sensor Monitoring App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            background: AppColors.background,
            surface: AppColors.elevated,
            error: AppColors.error,
          ),
          scaffoldBackgroundColor: AppColors.background,

          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: AppTypography.section.copyWith(
              color: AppColors.white,
            ),
          ),

          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 6,
          ),

          dividerTheme: DividerThemeData(
            color: AppColors.border,
            thickness: 1,
            space: 1,
          ),

          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return AppColors.white;
              }
              return AppColors.textSecondary;
            }),
            trackColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return AppColors.primary;
              }
              return AppColors.border;
            }),
          ),

          useMaterial3: true,
        ),
        home: const MonitoringSensor(),
        routes: {
          '/sensor-list': (_) => const DaftarSensor(),
          '/add-sensor': (_) => const TambahSensor(),
          '/history': (_) => const RiwayatData(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/sensor-detail') {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => DetailSensor(
                sensorId: args?['sensorId'],
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
