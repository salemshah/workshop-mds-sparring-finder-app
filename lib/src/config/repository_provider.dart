import 'package:provider/provider.dart';

import 'package:sparring_finder/src/services/api_service.dart';
import 'package:sparring_finder/src/repositories/user_repository.dart';
import 'package:sparring_finder/src/repositories/profile_rpository.dart';
import 'package:sparring_finder/src/repositories/availability_repository.dart';
import 'package:sparring_finder/src/repositories/sparring_repository.dart';

class RepositoryProviders {
  static final apiService = ApiService(baseUrl: "http://localhost:8000/api");

  static final userRepository = UserRepository(apiService: apiService);
  static final profileRepository = ProfileRepository(apiService: apiService);
  static final availabilityRepository = AvailabilityRepository(apiService: apiService);
  static final sparringRepository = SparringRepository(apiService: apiService);

  static List<Provider> all = [
    Provider<ApiService>.value(value: apiService),
    Provider<UserRepository>.value(value: userRepository),
    Provider<ProfileRepository>.value(value: profileRepository),
    Provider<AvailabilityRepository>.value(value: availabilityRepository),
    Provider<SparringRepository>.value(value: sparringRepository),
  ];
}
