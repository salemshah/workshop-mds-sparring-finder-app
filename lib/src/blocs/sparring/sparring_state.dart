import 'package:equatable/equatable.dart';
import 'package:sparring_finder/src/models/sparring/sparring_model.dart';

abstract class SparringState extends Equatable {
  const SparringState();

  @override
  List<Object?> get props => [];
}

class SparringInitial extends SparringState {
  const SparringInitial();
}

class SparringLoadInProgress extends SparringState {
  const SparringLoadInProgress();
}

class SparringLoadSuccess extends SparringState {
  final List<Sparring> sparrings;

  const SparringLoadSuccess(this.sparrings);

  @override
  List<Object?> get props => [sparrings];
}

class SparringSingleSuccess extends SparringState {
  final Sparring sparring;

  const SparringSingleSuccess(this.sparring);

  @override
  List<Object?> get props => [sparring];
}

class SparringOperationSuccess extends SparringState {
  final String message;
  final List<Sparring> sparrings;

  const SparringOperationSuccess(this.message, this.sparrings);

  @override
  List<Object?> get props => [message, sparrings];
}

class SparringFailure extends SparringState {
  final String error;

  const SparringFailure(this.error);

  @override
  List<Object?> get props => [error];
}
