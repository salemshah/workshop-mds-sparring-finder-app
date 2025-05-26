import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sparring_finder/src/blocs/onboarding/onboarding_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/blocs/profile/profile_bloc.dart';
import 'package:sparring_finder/src/blocs/availability/availability_bloc.dart';
import 'package:sparring_finder/src/blocs/availability/availability_event.dart';
import 'package:sparring_finder/src/blocs/sparring/sparring_bloc.dart';
import 'package:sparring_finder/src/blocs/notification/notification_bloc.dart';

import 'package:sparring_finder/src/config/repository_provider.dart';

import '../services/notification_service.dart';

class BlocProviders {
  static List<BlocProvider> all = [
    BlocProvider<OnBoardBloc>(create: (_) => OnBoardBloc()),
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
      create: (_) => AvailabilityBloc(repository: RepositoryProviders.availabilityRepository)
        ..add(const LoadAvailabilities()),
    ),
    BlocProvider<NotificationBloc>(
      create: (context) => NotificationBloc(
        context.read<NotificationService>(),
        RepositoryProviders.notificationRepository,
      ),
    ),
  ];
}
