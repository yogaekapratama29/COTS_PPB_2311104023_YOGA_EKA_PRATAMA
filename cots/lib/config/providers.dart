import 'package:flutter/foundation.dart';
import '../models/sensor_model.dart';
import '../models/sensor_history_model.dart';
import '../services/supabase_service.dart';

class SensorProvider with ChangeNotifier {
  final SupabaseService _service = SupabaseService();
  List<Sensor> _sensors = [];
  List<SensorHistory> _history = [];
  List<Sensor> get sensors => _sensors;
  List<SensorHistory> get history => _history;

  List<Sensor> get activeSensors =>
      _sensors.where((s) => s.isActive).toList();

  List<Sensor> get inactiveSensors =>
      _sensors.where((s) => !s.isActive).toList();
  Sensor? getSensorById(String id) {
    try {
      return _sensors.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
  List<SensorHistory> getHistoryBySensorId(String sensorId) {
    return _history.where((h) => h.sensorId == sensorId).toList();
  }
  Future<void> loadFromSupabase() async {
    _sensors = await _service.fetchSensors();
    _history = await _service.fetchHistory();
    notifyListeners();
  }
  Future<void> addSensor(Sensor sensor) async {
    await _service.insertSensor(sensor);
    await loadFromSupabase();
  }
  Future<void> toggleSensorStatus(String id) async {
    final sensor = getSensorById(id);
    if (sensor == null) return;

    await _service.updateSensorStatus(id, !sensor.isActive);
    await loadFromSupabase();
  }
  Future<void> updateSensorValue(String id, double newValue) async {
    final sensor = getSensorById(id);
    if (sensor == null) return;

    await _service.updateSensorValue(id, newValue);
    await _service.insertHistory(
      sensorId: id,
      sensorName: sensor.name,
      value: newValue,
      unit: sensor.unit,
    );

    await loadFromSupabase();
  }

  Future<void> deleteSensor(String id) async {
    await _service.deleteSensor(id);
    await loadFromSupabase();
  }
}
