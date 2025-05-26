import 'package:equatable/equatable.dart';
import '../../models/profile/profile_model.dart';

// ---------------------------------------------------------------------------
// States related to athlete (public) profiles
// ---------------------------------------------------------------------------

abstract class AthletesState extends Equatable {
  const AthletesState();

  @override
  List<Object?> get props => [];
}

class AthletesInitial extends AthletesState {
  const AthletesInitial();
}

class AthletesLoadInProgress extends AthletesState {
  const AthletesLoadInProgress();
}

class AthletesFailure extends AthletesState {
  final String error;

  const AthletesFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AthletesLoadSuccess extends AthletesState {
  final List<Profile> profiles;

  const AthletesLoadSuccess(this.profiles);

  @override
  List<Object?> get props => [profiles];
}
