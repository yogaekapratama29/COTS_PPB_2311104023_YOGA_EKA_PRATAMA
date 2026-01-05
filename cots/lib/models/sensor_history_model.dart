class SensorHistory {
  final String id;
  final String sensorId;
  final String sensorName;
  final double value;
  final String unit;
  final DateTime timestamp;
  final String? note;

  SensorHistory({
    required this.id,
    required this.sensorId,
    required this.sensorName,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sensor_id': sensorId,
      'sensor_name': sensorName,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }

  factory SensorHistory.fromJson(Map<String, dynamic> json) {
    return SensorHistory(
      id: json['id'],
      sensorId: json['sensor_id'],
      sensorName: json['sensor_name'],
      value: (json['value'] as num).toDouble(),
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
      note: json['note'],
    );
  }
}
