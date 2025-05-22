import 'availability_model.dart';

class AvailabilityResponse {
  final String? message; // present on create / update
  final List<Availability> availabilities;

  AvailabilityResponse({
    this.message,
    required this.availabilities,
  });

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) {
    final list = json['availabilities'] as List<dynamic>? ?? [];
    return AvailabilityResponse(
      message: json['message'] as String?,
      availabilities: list
          .map((e) => Availability.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
