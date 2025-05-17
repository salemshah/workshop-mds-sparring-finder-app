import 'package:sparring_finder/src/models/user/user_login_response.dart';
import 'package:sparring_finder/src/repositories/base_repository.dart';

class UserRepository extends BaseRepository {
  UserRepository({required super.apiService});

  Future<String> registerUser({
    required String email,
    required String password,
  }) async {
    final data = {"email": email, "password": password};
    final response = await apiService.post('/user/register', data);
    return response['message'];
  }

  Future<UserLoginResponse> loginUser({
    required String email,
    required String password,
  }) async {
    final data = {"email": email, "password": password};
    final response = await apiService.post('/user/login', data);
    return UserLoginResponse.fromJson(response);
  }

  Future<String> verifyEmail({required String code}) async {
    final data = {"code": code};
    final response = await apiService.post('/user/verify-email', data);
    return response['message'];
  }

  Future<String> resendVerification({required String email}) async {
    final data = {"email": email};
    final response = await apiService.post('/user/resend-verification', data);
    return response['message'];
  }

  Future<String> forgotPassword({required String email}) async {
    final data = {"email": email};
    final response = await apiService.post('/user/forgot-password', data);
    return response['message'];
  }

  Future<String> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    final data = {"code": code, "newPassword": newPassword};
    final response = await apiService.put('/user/reset-password', data);
    return response['message'];
  }
}
