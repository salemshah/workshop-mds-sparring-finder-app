import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/repositories/user_repository.dart';
import 'package:sparring_finder/src/services/api_service.dart';
import '../blocs/profile/profile_bloc.dart';
import '../repositories/profile_rpository.dart';

class BlocProviders {
  static final apiService = ApiService(
    baseUrl: "http://localhost:8000/api",
  );

  static final userRepository = UserRepository(apiService: apiService);
  static final profileRepository = ProfileRepository(apiService: apiService);

  static List<BlocProvider> all = [
    BlocProvider<UserBloc>(
      create: (_) => UserBloc(userRepository: userRepository),
    ),
    BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(profileRepository: profileRepository),
    ),
  ];
}
