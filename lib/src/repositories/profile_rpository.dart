import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:sparring_finder/src/repositories/base_repository.dart';
import '../models/profile/profile_model.dart';
import '../models/profile/profile_response.dart';

class ProfileRepository extends BaseRepository {
  ProfileRepository({required super.apiService});

  /// GET /profile - Fetch the authenticated user's profile
  Future<ProfileResponse> getProfile() async {
    final response = await apiService.get('/profile');
    return ProfileResponse.fromJson(response);
  }

  /// GET /profile/exists - Check if user has a profile
  Future<bool> hasProfile() async {
    final response = await apiService.get('/profile/exists');
    return response['hasProfile'] ?? false;
  }

  /// POST /profile - Create a profile
  Future<ProfileResponse> createProfile(Map<String, dynamic> data, {File? photo}) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${apiService.baseUrl}/profile'),
    );

    request.headers.addAll(await apiService.getAuthHeaders());
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (photo != null) {
      final mimeType = lookupMimeType(photo.path) ?? 'image/jpeg';
      final file = await http.MultipartFile.fromPath(
        'photo',
        photo.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(file);
    }

    final streamedResponse = await request.send();
    final json = await apiService.handleMultipartResponse(streamedResponse);
    return ProfileResponse.fromJson(json);
  }

  /// PUT /profile - Update the profile
  Future<ProfileResponse> updateProfile(Map<String, dynamic> data) async {
    final response = await apiService.put('/profile', data);
    return ProfileResponse.fromJson(response);
  }

  /// PATCH /profile/photo - Upload/update profile photo
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
    final streamedResponse = await request.send();
    final json = await apiService.handleMultipartResponse(streamedResponse);
    return ProfileResponse.fromJson(json);
  }

  /// DELETE /profile - Delete the profile
  Future<String> deleteProfile() async {
    final response = await apiService.delete('/profile');
    return response['message'] ?? 'Profile deleted';
  }

  /// GET /profile/all - List all profiles
  Future<List<ProfileModel>> getAllProfiles() async {
    final response = await apiService.get('/profile/all');
    final list = response['profiles'] as List;
    return list.map((e) => ProfileModel.fromJson(e)).toList();
  }

  Future<List<ProfileModel>> searchProfiles(String query) async {
    final response = await apiService.get('/profile/search?q=$query');
    final List data = response['profiles']; // assuming server returns { profiles: [...] }
    return data.map((json) => ProfileModel.fromJson(json)).toList();
  }
}
