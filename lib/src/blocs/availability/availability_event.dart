import 'package:equatable/equatable.dart';


/// Base class for every Availability event.
abstract class AvailabilityEvent extends Equatable {
  const AvailabilityEvent();

  @override
  List<Object?> get props => [];
}

/// GET `/availability`
class LoadAvailabilities extends AvailabilityEvent {
  const LoadAvailabilities();
}

/// GET /availability/all/:targetUserId
class LoadAvailabilitiesByTargetUserId extends AvailabilityEvent {
  final int targetUserId;
  const LoadAvailabilitiesByTargetUserId(this.targetUserId);

  @override
  List<Object?> get props => [targetUserId];
}

/// GET /availability/:id
class LoadAvailabilityById extends AvailabilityEvent {
  final int id;
  const LoadAvailabilityById(this.id);

  @override
  List<Object?> get props => [id];
}

/// POST `/availability`
class CreateAvailability extends AvailabilityEvent {
  final Map<String, dynamic> data;
  const CreateAvailability(this.data);

  @override
  List<Object?> get props => [data];
}

/// PUT `/availability/:id`
class UpdateAvailability extends AvailabilityEvent {
  final int id;
  final Map<String, dynamic> data;
  const UpdateAvailability(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

/// DELETE `/availability/:id`
class DeleteAvailability extends AvailabilityEvent {
  final int id;
  const DeleteAvailability(this.id);

  @override
  List<Object?> get props => [id];
}
