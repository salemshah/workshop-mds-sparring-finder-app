import '../sparring/sparring_model.dart';

class Availability {
  final int id;
  final int userId;
  final DateTime specificDate;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Sparring> sparrings;

  Availability({
    required this.id,
    required this.userId,
    required this.specificDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    this.sparrings = const [],
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    final sparringList = (json['sparrings'] as List<dynamic>?)
            ?.map((e) => Sparring.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <Sparring>[];

    return Availability(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      specificDate: DateTime.parse(json['specific_date'] as String),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      sparrings: sparringList,
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
      'sparrings': sparrings.map((s) => s.toJson()).toList(),
    };
  }

  Availability copyWith({
    int? id,
    int? userId,
    DateTime? specificDate,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Sparring>? sparrings,
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
      sparrings: sparrings ?? this.sparrings,
    );
  }

  @override
  String toString() {
    return 'Availability('
        'id: $id, '
        'userId: $userId, '
        'specificDate: ${specificDate.toIso8601String()}, '
        'startTime: ${startTime.toIso8601String()}, '
        'endTime: ${endTime.toIso8601String()}, '
        'location: $location, '
        'createdAt: ${createdAt.toIso8601String()}, '
        'updatedAt: ${updatedAt.toIso8601String()}, '
        'sparrings: $sparrings'
        ')';
  }
}
