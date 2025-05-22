class Availability {
  final int id;
  final int userId;
  final DateTime specificDate;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;

  Availability({
    required this.id,
    required this.userId,
    required this.specificDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      id: json['id'],
      userId: json['user_id'],
      specificDate: DateTime.parse(json['specific_date']),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      location: json['location'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'specific_date': specificDate.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Optional: For form updates
  Availability copyWith({
    int? id,
    int? userId,
    DateTime? specificDate,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Availability(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      specificDate: specificDate ?? this.specificDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
