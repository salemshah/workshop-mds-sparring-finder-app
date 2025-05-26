import 'package:equatable/equatable.dart';

// ---------------------------------------------------------------------------
// Events for managing athletes (public profiles)
// ---------------------------------------------------------------------------

abstract class AthletesEvent extends Equatable {
  const AthletesEvent();

  @override
  List<Object?> get props => [];
}

class AthletesFetched extends AthletesEvent {
  const AthletesFetched();
}

class AthletesSearched extends AthletesEvent {
  final String query;

  const AthletesSearched(this.query);

  @override
  List<Object?> get props => [query];
}

class AthletesFiltered extends AthletesEvent {
  final String? level;
  final String? country;
  final String? city;
  final String? gender;
  final double? maxWeight;
  final double? minWeight;

  const AthletesFiltered({
    this.level,
    this.country,
    this.city,
    this.gender,
    this.maxWeight,
    this.minWeight,
  });

  @override
  List<Object?> get props => [
    level,
    country,
    city,
    gender,
    maxWeight,
    minWeight,
  ];
}

class FavoriteToggledForAthlete extends AthletesEvent {
  final int targetUserId;
  final int currentUserId;

  const FavoriteToggledForAthlete({
    required this.targetUserId,
    required this.currentUserId,
  });

  @override
  List<Object?> get props => [targetUserId, currentUserId];
}
