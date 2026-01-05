import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sensor_model.dart';
import '../models/sensor_history_model.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;
  Future<List<Sensor>> fetchSensors() async {
    final response = await supabase
        .from('sensors')
        .select()
        .order('created_at');

    return response.map<Sensor>((e) => Sensor.fromJson(e)).toList();
  }

  Future<void> insertSensor(Sensor sensor) async {
    await supabase.from('sensors').insert(sensor.toJson());
  }

  Future<void> updateSensorValue(String id, double value) async {
    await supabase.from('sensors').update({
      'current_value': value,
      'last_updated': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> updateSensorStatus(String id, bool isActive) async {
    await supabase.from('sensors').update({
      'is_active': isActive,
      'last_updated': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> deleteSensor(String id) async {
    await supabase.from('sensors').delete().eq('id', id);
  }

  Future<List<SensorHistory>> fetchHistory() async {
    final response = await supabase
        .from('sensor_history')
        .select()
        .order('timestamp', ascending: false);

    return response
        .map<SensorHistory>((e) => SensorHistory.fromJson(e))
        .toList();
  }

  Future<void> insertHistory({
    required String sensorId,
    required String sensorName,
    required double value,
    required String unit,
  }) async {
    await supabase.from('sensor_history').insert({
      'sensor_id': sensorId,
      'sensor_name': sensorName,
      'value': value,
      'unit': unit,
    });
  }
}
