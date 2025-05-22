import 'package:equatable/equatable.dart';

import '../../models/availability/availability_model.dart';

/// Base class for every Availability state.
abstract class AvailabilityState extends Equatable {
  const AvailabilityState();

  @override
  List<Object?> get props => [];
}

class AvailabilityInitial extends AvailabilityState {
  const AvailabilityInitial();
}

class AvailabilityLoadInProgress extends AvailabilityState {
  const AvailabilityLoadInProgress();
}

class AvailabilityLoadSuccess extends AvailabilityState {
  final List<Availability> availabilities;
  const AvailabilityLoadSuccess(this.availabilities);

  @override
  List<Object?> get props => [availabilities];
}

/// Successful fetch of ONE slot
class AvailabilitySingleSuccess extends AvailabilityState {
  final Availability availability;
  const AvailabilitySingleSuccess(this.availability);

  @override
  List<Object?> get props => [availability];
}

/// Returned after create / update / delete
class AvailabilityOperationSuccess extends AvailabilityState {
  final String message;
  final List<Availability> availabilities;
  const AvailabilityOperationSuccess(this.message, this.availabilities);

  @override
  List<Object?> get props => [message, availabilities];
}

class AvailabilityFailure extends AvailabilityState {
  final String error;
  const AvailabilityFailure(this.error);

  @override
  List<Object?> get props => [error];
}
