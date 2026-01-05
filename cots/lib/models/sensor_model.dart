class Sensor {
  final String id;
  final String name;
  final String type;
  final String location;
  final bool isActive;
  final double currentValue;
  final String unit;
  final DateTime lastUpdated;
  final String? description;
  final double? minValue;
  final double? maxValue;

  Sensor({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.isActive,
    required this.currentValue,
    required this.unit,
    required this.lastUpdated,
    this.description,
    this.minValue,
    this.maxValue,
  });

  Sensor copyWith({
    String? id,
    String? name,
    String? type,
    String? location,
    bool? isActive,
    double? currentValue,
    String? unit,
    DateTime? lastUpdated,
    String? description,
    double? minValue,
    double? maxValue,
  }) {
    return Sensor(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      description: description ?? this.description,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'location': location,
      'is_active': isActive,
      'current_value': currentValue,
      'unit': unit,
      'last_updated': lastUpdated.toIso8601String(),
      'description': description,
      'min_value': minValue,
      'max_value': maxValue,
    };
  }

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      location: json['location'] ?? '',
      isActive: json['is_active'] ?? false,
      currentValue: (json['current_value'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
      lastUpdated: DateTime.parse(json['last_updated']),
      description: json['description'],
      minValue: (json['min_value'] as num?)?.toDouble(),
      maxValue: (json['max_value'] as num?)?.toDouble(),
    );
  }


  String get status {
    if (!isActive) return 'Tidak Aktif';
    if (maxValue != null && currentValue > maxValue!) return 'Bahaya';
    if (minValue != null && currentValue < minValue!) return 'Peringatan';
    return 'Normal';
  }
}
