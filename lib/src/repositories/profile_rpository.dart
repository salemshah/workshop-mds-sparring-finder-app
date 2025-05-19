import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:sparring_finder/src/repositories/base_repository.dart';

import '../models/profile/profile_model.dart';
import '../models/profile/profile_response.dart';

/// Data-layer interface for every `/profile` and `/favorite` API endpoint.
class ProfileRepository extends BaseRepository {
  ProfileRepository({required super.apiService});

  // ----------------------------- PROFILE ---------------------------------- //

  /// GET `/profile` — Fetch the authenticated user's full profile details.
  Future<ProfileResponse> getProfile() async {
    final response = await apiService.get('/profile');
    return ProfileResponse.fromJson(response);
  }

  /// GET `/profile/exists` — Check whether the current user already has a profile.
  Future<bool> hasProfile() async {
    final response = await apiService.get('/profile/exists');
    return response['hasProfile'] ?? false;
  }

  /// POST `/profile` — Create a profile. Accepts optional [photo] upload.
  Future<ProfileResponse> createProfile(
      Map<String, dynamic> data, {
        File? photo,
      }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${apiService.baseUrl}/profile'),
    );

    request.headers.addAll(await apiService.getAuthHeaders());
    data.forEach((key, value) => request.fields[key] = value.toString());

    if (photo != null) {
      final mimeType = lookupMimeType(photo.path) ?? 'image/jpeg';
      final file = await http.MultipartFile.fromPath(
        'photo',
        photo.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(file);
    }

    final streamed = await request.send();
    final json = await apiService.handleMultipartResponse(streamed);
    return ProfileResponse.fromJson(json);
  }

  /// PUT `/profile` — Update profile fields (no image).
  Future<ProfileResponse> updateProfile(Map<String, dynamic> data) async {
    final response = await apiService.put('/profile', data);
    return ProfileResponse.fromJson(response);
  }

  /// PATCH `/profile/photo` — Upload or change the profile picture.
  Future<ProfileResponse> updateProfilePhoto(File photo) async {
    final mimeType = lookupMimeType(photo.path) ?? 'image/jpeg';
    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse('${apiService.baseUrl}/profile/photo'),
    );

    request.headers.addAll(await apiService.getAuthHeaders());
    final file = await http.MultipartFile.fromPath(
      'photo',
      photo.path,
      contentType: MediaType.parse(mimeType),
    );

    request.files.add(file);
    final streamed = await request.send();
    final json = await apiService.handleMultipartResponse(streamed);
    return ProfileResponse.fromJson(json);
  }

  /// DELETE `/profile` — Delete the authenticated user's profile.
  Future<String> deleteProfile() async {
    final response = await apiService.delete('/profile');
    return response['message'] ?? 'Profile deleted';
  }

  /// GET `/profile/all` — Retrieve every profile (no auth required depending on backend).
  Future<List<Profile>> getAllProfiles() async {
    final response = await apiService.get('/profile/all');
    final list = response['profiles'] as List<dynamic>;
    return list.map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// GET `/profile/search` — Simple full-text search.
  Future<List<Profile>> searchProfiles(String query) async {
    final response = await apiService.get('/profile/search?q=$query');
    final List data = response['profiles'];
    return data.map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// GET `/profile/filter` — Advanced querying via query params.
  Future<List<Profile>> filterProfiles({
    String? level,
    String? country,
    String? city,
    String? gender,
    double? maxWeight,
    double? minWeight,
  }) async {
    final query = <String, String>{
      if (level != null) 'level': level,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (gender != null) 'gender': gender,
      if (maxWeight != null) 'maxWeight': maxWeight.toInt().toString(),
      if (minWeight != null) 'minWeight': minWeight.toInt().toString(),
    };

    final uri = Uri(queryParameters: query).query;
    final response = await apiService.get('/profile/filter?$uri');
    final List data = response['profiles'];
    return data.map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ----------------------------- FAVORITES -------------------------------- //

  /// POST `/favorite/toggle` — Mark/unmark [targetUserId] as a favorite.
  Future<void> toggleFavorite({required int targetUserId}) async {
    try {
      await apiService.post('/favorite/toggle', {
        'targetUserId': targetUserId,
      });
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }
}