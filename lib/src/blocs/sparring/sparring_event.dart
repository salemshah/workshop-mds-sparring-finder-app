import 'package:equatable/equatable.dart';

abstract class SparringEvent extends Equatable {
  const SparringEvent();

  @override
  List<Object?> get props => [];
}

// -------------------------------------------------------------------------
// GET /sparring — get all sparrings for current user
// -------------------------------------------------------------------------
class LoadSparrings extends SparringEvent {}

// -------------------------------------------------------------------------
// GET /sparring — get all sparrings for current user
// -------------------------------------------------------------------------
class LoadSparringsByUserIdAndPartnerId extends SparringEvent {
  final int partnerId;

  const LoadSparringsByUserIdAndPartnerId(this.partnerId);

  @override
  List<Object?> get props => [partnerId];
}

// -------------------------------------------------------------------------
// GET /sparring/:id — get single sparring
// -------------------------------------------------------------------------
class LoadSparringById extends SparringEvent {
  final int id;

  const LoadSparringById(this.id);

  @override
  List<Object?> get props => [id];
}

// -------------------------------------------------------------------------
// POST /sparring — create a sparring
// -------------------------------------------------------------------------
class CreateSparring extends SparringEvent {
  final Map<String, dynamic> data;
  final int partnerId;
  const CreateSparring(this.data, this.partnerId);

  @override
  List<Object?> get props => [data];
}

// -------------------------------------------------------------------------
// PUT /sparring/:id — update a sparring
// -------------------------------------------------------------------------
class UpdateSparring extends SparringEvent {
  final int id;
  final int partnerId;
  final Map<String, dynamic> data;

  const UpdateSparring(this.id, this.data, this.partnerId);

  @override
  List<Object?> get props => [id, data, partnerId];
}

// -------------------------------------------------------------------------
// POST /sparring/:id/confirm — confirm a sparring
// -------------------------------------------------------------------------
class ConfirmSparring extends SparringEvent {
  final int id;

  const ConfirmSparring(this.id);

  @override
  List<Object?> get props => [id];
}

// -------------------------------------------------------------------------
// POST /sparring/:id/cancel — cancel a sparring
// -------------------------------------------------------------------------
class CancelSparring extends SparringEvent {
  final int id;
  final int? partnerId;
  final Map<String, dynamic>? data;

  const CancelSparring({required this.id, this.data, this.partnerId});

  @override
  List<Object?> get props => [id, data, partnerId];
}
