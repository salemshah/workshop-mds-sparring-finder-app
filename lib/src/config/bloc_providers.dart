// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sparring_finder/src/blocs/sparring/sparring_bloc.dart';
// import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
// import 'package:sparring_finder/src/repositories/sparring_repository.dart';
// import 'package:sparring_finder/src/repositories/user_repository.dart';
// import 'package:sparring_finder/src/services/api_service.dart';
// import '../blocs/availability/availability_bloc.dart';
// import '../blocs/availability/availability_event.dart';
// import '../blocs/onboarding/onboarding_bloc.dart';
// import '../blocs/profile/profile_bloc.dart';
// import '../repositories/availability_repository.dart';
// import '../repositories/profile_rpository.dart';
//
// class BlocProviders {
//   static final apiService = ApiService(
//     baseUrl: "http://localhost:8000/api",
//   );
//
//   static final userRepository = UserRepository(apiService: apiService);
//   static final profileRepository = ProfileRepository(apiService: apiService);
//   static final availabilityRepository = AvailabilityRepository(apiService: apiService);
//   static final sparringSessionRepository = SparringRepository(apiService: apiService);
//
//   static List<BlocProvider> all = [
//     BlocProvider<OnBoardBloc>(
//       create: (_) => OnBoardBloc(),
//     ),
//     BlocProvider<UserBloc>(
//       create: (_) => UserBloc(userRepository: userRepository),
//     ),
//     BlocProvider<ProfileBloc>(
//       create: (_) => ProfileBloc(repository: profileRepository),
//     ),
//     BlocProvider(
//         create: (_) => SparringBloc(repository: sparringSessionRepository)
//     ),
//     BlocProvider<AvailabilityBloc>(
//       create: (_) => AvailabilityBloc(
//         repository: availabilityRepository,
//       )..add(const LoadAvailabilities()),
//     ),
//   ];
// }


// lib/src/blocs/bloc_providers.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/onboarding/onboarding_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/blocs/profile/profile_bloc.dart';
import 'package:sparring_finder/src/blocs/availability/availability_bloc.dart';
import 'package:sparring_finder/src/blocs/availability/availability_event.dart';
import 'package:sparring_finder/src/blocs/sparring/sparring_bloc.dart';
import 'package:sparring_finder/src/config/repository_provider.dart';

class BlocProviders {
  static List<BlocProvider> all = [
    BlocProvider<OnBoardBloc>(
      create: (_) => OnBoardBloc(),
    ),
    BlocProvider<UserBloc>(
      create: (_) => UserBloc(userRepository: RepositoryProviders.userRepository),
    ),
    BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(repository: RepositoryProviders.profileRepository),
    ),
    BlocProvider<SparringBloc>(
      create: (_) => SparringBloc(repository: RepositoryProviders.sparringRepository),
    ),
    BlocProvider<AvailabilityBloc>(
      create: (_) => AvailabilityBloc(
        repository: RepositoryProviders.availabilityRepository,
      )..add(const LoadAvailabilities()),
    ),
  ];
}
