import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/repositories/user_repository.dart';
import 'package:sparring_finder/src/services/api_service.dart';
import '../blocs/availability/availability_bloc.dart';
import '../blocs/availability/availability_event.dart';
import '../blocs/onboarding/onboarding_bloc.dart';
import '../blocs/profile/profile_bloc.dart';
import '../repositories/availability_repository.dart';
import '../repositories/profile_rpository.dart';

class BlocProviders {
  static final apiService = ApiService(
    baseUrl: "http://localhost:8000/api",
  );

  static final userRepository = UserRepository(apiService: apiService);
  static final profileRepository = ProfileRepository(apiService: apiService);
  static final availabilityRepository = AvailabilityRepository(apiService: apiService);

  static List<BlocProvider> all = [
    BlocProvider<OnBoardBloc>(
      create: (_) => OnBoardBloc(),
    ),
    BlocProvider<UserBloc>(
      create: (_) => UserBloc(userRepository: userRepository),
    ),
    BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(repository: profileRepository),
    ),

    BlocProvider<AvailabilityBloc>(
      create: (_) => AvailabilityBloc(
        repository: availabilityRepository,
      )..add(const LoadAvailabilities()),
    ),
  ];
}
