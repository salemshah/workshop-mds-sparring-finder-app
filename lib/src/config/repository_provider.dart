import 'package:provider/provider.dart';

import 'package:sparring_finder/src/services/api_service.dart';
import 'package:sparring_finder/src/services/notification_service.dart';

import 'package:sparring_finder/src/repositories/user_repository.dart';
import 'package:sparring_finder/src/repositories/profile_rpository.dart';
import 'package:sparring_finder/src/repositories/availability_repository.dart';
import 'package:sparring_finder/src/repositories/sparring_repository.dart';
import 'package:sparring_finder/src/repositories/notification_repository.dart';

class RepositoryProviders {

  // Unexpectedly found more than one Dart VM Service report for com.sparringfinder.app._dartVmService._tcp.local - using first one (50178).
  // static final ApiService apiService = ApiService(baseUrl: "http://localhost:8000/api");
  static final ApiService apiService = ApiService(baseUrl: "http://172.20.10.3:8000/api"); // for real iphone

  static final UserRepository userRepository = UserRepository(apiService: apiService);
  static final ProfileRepository profileRepository = ProfileRepository(apiService: apiService);
  static final AvailabilityRepository availabilityRepository = AvailabilityRepository(apiService: apiService);
  static final SparringRepository sparringRepository = SparringRepository(apiService: apiService);
  static final NotificationRepository notificationRepository = NotificationRepository(apiService);

  static List<Provider> getAll(NotificationService notificationService) => [
    Provider<ApiService>.value(value: apiService),
    Provider<UserRepository>.value(value: userRepository),
    Provider<ProfileRepository>.value(value: profileRepository),
    Provider<AvailabilityRepository>.value(value: availabilityRepository),
    Provider<SparringRepository>.value(value: sparringRepository),
    Provider<NotificationService>.value(value: notificationService),
    Provider<NotificationRepository>.value(value: notificationRepository),
  ];
}
