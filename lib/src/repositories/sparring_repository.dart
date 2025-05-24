import 'package:sparring_finder/src/repositories/base_repository.dart';
import 'package:sparring_finder/src/models/sparring/sparring_model.dart';
import 'package:sparring_finder/src/models/sparring/sparring_response.dart';

/// Data-layer interface for every `/sparring` API endpoint.
class SparringRepository extends BaseRepository {
  SparringRepository({required super.apiService});

  // -------------------------------------------------------------------------
  // GET `/sparring` — all sparrings for the authenticated user
  // -------------------------------------------------------------------------
  Future<List<Sparring>> getSparrings() async {
    final response = await apiService.get('/sparring');
    final list = response['sparrings'] as List<dynamic>;
    return list
        .map((e) => Sparring.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // -------------------------------------------------------------------------
  // GET `/sparring/:id` — get a single sparring
  // -------------------------------------------------------------------------
  Future<Sparring?> getSparringById(int id) async {
    final response = await apiService.get('/sparring/$id');
    final list = response['sparrings'] as List<dynamic>;
    if (list.isEmpty) return null;
    return Sparring.fromJson(list.first as Map<String, dynamic>);
  }

  // -------------------------------------------------------------------------
  // POST `/sparring` — create a sparring request
  // -------------------------------------------------------------------------
  Future<SparringResponse> createSparring(Map<String, dynamic> data) async {
    final response = await apiService.post('/sparring', data);
    return SparringResponse.fromJson(response);
  }

  // -------------------------------------------------------------------------
  // PUT `/sparring/:id` — update a sparring
  // -------------------------------------------------------------------------
  Future<SparringResponse> updateSparring(
      int id, Map<String, dynamic> data) async {
    final response = await apiService.put('/sparring/$id', data);
    return SparringResponse.fromJson(response);
  }

  // -------------------------------------------------------------------------
  // POST `/sparring/:id/confirm` — confirm a sparring
  // -------------------------------------------------------------------------
  Future<SparringResponse> confirmSparring(int id) async {
    final response = await apiService.post('/sparring/$id/confirm', {});
    return SparringResponse.fromJson(response);
  }

  // -------------------------------------------------------------------------
  // POST `/sparring/:id/cancel` — cancel a sparring
  // -------------------------------------------------------------------------
  Future<SparringResponse> cancelSparring(
      int id, Map<String, dynamic> data) async {
    final response = await apiService.post('/sparring/$id/cancel', data);
    return SparringResponse.fromJson(response);
  }
}
