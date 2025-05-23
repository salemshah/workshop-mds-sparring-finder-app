import 'package:sparring_finder/src/repositories/base_repository.dart';
import 'package:sparring_finder/src/models/availability/availability_model.dart';
import 'package:sparring_finder/src/models/availability/availability_response.dart';

/// Data-layer interface for every `/availability` API endpoint.
class AvailabilityRepository extends BaseRepository {
  AvailabilityRepository({required super.apiService});

  /// -------------------------------------------------------------------------
  /// GET `/availability` — all availabilities for the authenticated user
  /// -------------------------------------------------------------------------
  Future<List<Availability>> getAvailabilities() async {
    final response = await apiService.get('/availability');
    final list = response['availabilities'] as List<dynamic>;
    return list
        .map((e) => Availability.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// -------------------------------------------------------------------------
  /// GET /availability — all availabilities for targetUserId
  /// -------------------------------------------------------------------------
  Future<List<Availability>> getAvailabilitiesByTargetUserId(targetUserId) async {
    final response = await apiService.get('/availability/all/$targetUserId');
    final list = response['availabilities'] as List<dynamic>;
    return list
        .map((e) => Availability.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // -------------------------------------------------------------------------
  // GET /availability/:id — single availability by ID
  // -------------------------------------------------------------------------
  Future<Availability?> getAvailabilityById(int id) async {
    final response = await apiService.get('/availability/$id');
    final list = response['availabilities'] as List<dynamic>;
    if (list.isEmpty) return null;
    return Availability.fromJson(list.first as Map<String, dynamic>);
  }

  // -------------------------------------------------------------------------
  // POST /availability — create a new availability slot
  // -------------------------------------------------------------------------
  Future<AvailabilityResponse> createAvailability(
      Map<String, dynamic> data) async {
    final response = await apiService.post('/availability', data);
    return AvailabilityResponse.fromJson(response);
  }

  // -------------------------------------------------------------------------
  // PUT /availability/:id — update an existing slot
  // -------------------------------------------------------------------------
  Future<AvailabilityResponse> updateAvailability(
      int id, Map<String, dynamic> data) async {
    final response = await apiService.put('/availability/$id', data);
    return AvailabilityResponse.fromJson(response);
  }

  // -------------------------------------------------------------------------
  // DELETE /availability/:id — delete a slot
  // -------------------------------------------------------------------------
  Future<String> deleteAvailability(int id) async {
    final response = await apiService.delete('/availability/$id');
    // Backend returns { "message": "Availability deleted successfully" }
    return response['message'] ?? 'Availability deleted';
  }


}
