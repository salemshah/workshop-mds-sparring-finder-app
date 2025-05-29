import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/onboarding/onboarding_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/blocs/availability/availability_bloc.dart';
import 'package:sparring_finder/src/blocs/availability/availability_event.dart';
import 'package:sparring_finder/src/blocs/sparring/sparring_bloc.dart';
import 'package:sparring_finder/src/blocs/notification/notification_bloc.dart';
import 'package:sparring_finder/src/blocs/athletes/athletes_bloc.dart';
import 'package:sparring_finder/src/blocs/profile/profile_bloc.dart';
import 'package:sparring_finder/src/services/notification_service.dart';
import 'package:sparring_finder/src/config/repository_provider.dart';

class BlocProviders {
  static List<BlocProvider> all(NotificationService notificationService) => [
        BlocProvider<OnBoardBloc>(create: (_) => OnBoardBloc()),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(
            userRepository: RepositoryProviders.userRepository,
          ),
        ),
        BlocProvider<AthletesBloc>(
          create: (_) => AthletesBloc(
            repository: RepositoryProviders.profileRepository,
          ),
        ),
        BlocProvider<SparringBloc>(
          create: (_) => SparringBloc(
            repository: RepositoryProviders.sparringRepository,
          ),
        ),
        BlocProvider<AvailabilityBloc>(
          create: (_) => AvailabilityBloc(
            repository: RepositoryProviders.availabilityRepository,
          )..add(const LoadAvailabilities()),
        ),
        BlocProvider<MyProfileBloc>(
          create: (_) => MyProfileBloc(
            repository: RepositoryProviders.profileRepository,
          ),
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => NotificationBloc(
            notificationService,
            RepositoryProviders.notificationRepository,
          ),
        ),
      ];
}
