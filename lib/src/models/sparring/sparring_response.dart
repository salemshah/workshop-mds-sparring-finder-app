import 'sparring_model.dart';

class SparringResponse {
  final String? message; // present on create / update / cancel
  final List<Sparring> sparrings;

  SparringResponse({
    this.message,
    required this.sparrings,
  });

  factory SparringResponse.fromJson(Map<String, dynamic> json) {
    final list = json['sparrings'] as List<dynamic>? ?? [];
    return SparringResponse(
      message: json['message'] as String?,
      sparrings: list
          .map((e) => Sparring.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
