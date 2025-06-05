import 'package:provider/provider.dart';
import 'package:sparring_finder/src/repositories/contact_repository.dart';

import 'package:sparring_finder/src/services/api_service.dart';
import 'package:sparring_finder/src/services/notification_service.dart';
import 'package:sparring_finder/src/repositories/user_repository.dart';
import 'package:sparring_finder/src/repositories/profile_rpository.dart';
import 'package:sparring_finder/src/repositories/availability_repository.dart';
import 'package:sparring_finder/src/repositories/sparring_repository.dart';
import 'package:sparring_finder/src/repositories/notification_repository.dart';
import '../repositories/message_repository.dart';
import 'app_constants.dart';

class RepositoryProviders {
  static late ApiService apiService;
  static late UserRepository userRepository;
  static late ProfileRepository profileRepository;
  static late AvailabilityRepository availabilityRepository;
  static late SparringRepository sparringRepository;
  static late NotificationRepository notificationRepository;
  static late MessageRepository messageRepository;
  static late ContactRepository contactRepository;

  /// Now synchronous: immediately returns a List<Provider>.
  static List<Provider> init(NotificationService notificationService) {
    // Build exactly one ApiService using AppConstants.apiBaseUrl
    apiService = ApiService(baseUrl: AppConstants.apiBaseUrl);

    // Construct each repository with that same ApiService
    userRepository = UserRepository(apiService: apiService);
    profileRepository = ProfileRepository(apiService: apiService);
    availabilityRepository =
        AvailabilityRepository(apiService: apiService);
    sparringRepository = SparringRepository(apiService: apiService);
    notificationRepository =
        NotificationRepository(apiService: apiService);
    notificationRepository = NotificationRepository(apiService: apiService);
    contactRepository = ContactRepository(apiService: apiService);

    messageRepository = MessageRepository(apiService: apiService);
    // Return a list of Providers, exactly as before
    return [
      Provider<ApiService>.value(value: apiService),
      Provider<UserRepository>.value(value: userRepository),
      Provider<ProfileRepository>.value(value: profileRepository),
      Provider<AvailabilityRepository>.value(value: availabilityRepository),
      Provider<SparringRepository>.value(value: sparringRepository),
      Provider<NotificationService>.value(value: notificationService),
      Provider<NotificationRepository>.value(value: notificationRepository),
      Provider<MessageRepository>.value(value: messageRepository),
      Provider<ContactRepository>.value(value: contactRepository),
    ];
  }
}
