import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:sparring_finder/src/services/api_service.dart';
import 'package:sparring_finder/src/services/notification_service.dart';

import 'package:sparring_finder/src/repositories/user_repository.dart';
import 'package:sparring_finder/src/repositories/profile_rpository.dart';
import 'package:sparring_finder/src/repositories/availability_repository.dart';
import 'package:sparring_finder/src/repositories/sparring_repository.dart';
import 'package:sparring_finder/src/repositories/notification_repository.dart';

class RepositoryProviders {
  static late ApiService apiService;

  static late UserRepository userRepository;
  static late ProfileRepository profileRepository;
  static late AvailabilityRepository availabilityRepository;
  static late SparringRepository sparringRepository;
  static late NotificationRepository notificationRepository;

  static Future<List<Provider>> init(NotificationService notificationService) async {
    final deviceInfo = DeviceInfoPlugin();

    bool isPhysicalDevice = false;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      isPhysicalDevice = androidInfo.isPhysicalDevice ?? false;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      isPhysicalDevice = iosInfo.isPhysicalDevice ?? false;
    }

    final baseUrl = isPhysicalDevice
        ? 'http://172.20.10.3:8000/api'
        : 'http://localhost:8000/api';

    apiService = ApiService(baseUrl: baseUrl);
    userRepository = UserRepository(apiService: apiService);
    profileRepository = ProfileRepository(apiService: apiService);
    availabilityRepository = AvailabilityRepository(apiService: apiService);
    sparringRepository = SparringRepository(apiService: apiService);
    notificationRepository = NotificationRepository(apiService: apiService);

    return [
      Provider<ApiService>.value(value: apiService),
      Provider<UserRepository>.value(value: userRepository),
      Provider<ProfileRepository>.value(value: profileRepository),
      Provider<AvailabilityRepository>.value(value: availabilityRepository),
      Provider<SparringRepository>.value(value: sparringRepository),
      Provider<NotificationService>.value(value: notificationService),
      Provider<NotificationRepository>.value(value: notificationRepository),
    ];
  }
}
