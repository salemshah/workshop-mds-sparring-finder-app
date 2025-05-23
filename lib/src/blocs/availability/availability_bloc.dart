import 'package:bloc/bloc.dart';
import 'package:sparring_finder/src/repositories/availability_repository.dart';
import 'availability_event.dart';
import 'availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  final AvailabilityRepository repository;

  AvailabilityBloc({required this.repository})
      : super(const AvailabilityInitial()) {
    on<LoadAvailabilities>(_onLoadAll);
    on<LoadAvailabilitiesByTargetUserId>(_onLoadAllByTargetUserId);
    on<LoadAvailabilityById>(_onLoadOne);
    on<CreateAvailability>(_onCreate);
    on<UpdateAvailability>(_onUpdate);
    on<DeleteAvailability>(_onDelete);
  }

  /* --------------------------- Handlers --------------------------- */

  Future<void> _onLoadAll(
      LoadAvailabilities event, Emitter<AvailabilityState> emit) async {
    emit(const AvailabilityLoadInProgress());
    try {
      final list = await repository.getAvailabilities();
      emit(AvailabilityLoadSuccess(list));
    } catch (e) {
      emit(AvailabilityFailure(e.toString()));
    }
  }

  Future<void> _onLoadAllByTargetUserId(
      LoadAvailabilitiesByTargetUserId event, Emitter<AvailabilityState> emit) async {
    emit(const AvailabilityLoadInProgress());
    try {
      final list = await repository.getAvailabilitiesByTargetUserId(event.targetUserId);
      emit(AvailabilityLoadSuccess(list));
    } catch (e) {
      emit(AvailabilityFailure(e.toString()));
    }
  }

  Future<void> _onLoadOne(
      LoadAvailabilityById event, Emitter<AvailabilityState> emit) async {
    emit(const AvailabilityLoadInProgress());
    try {
      final slot = await repository.getAvailabilityById(event.id);
      if (slot == null) {
        emit(const AvailabilityFailure('Availability not found'));
      } else {
        emit(AvailabilitySingleSuccess(slot));
      }
    } catch (e) {
      emit(AvailabilityFailure(e.toString()));
    }
  }

  Future<void> _onCreate(
      CreateAvailability event, Emitter<AvailabilityState> emit) async {
    emit(const AvailabilityLoadInProgress());
    try {
      final resp = await repository.createAvailability(event.data);
      emit(AvailabilityOperationSuccess(
          resp.message ?? 'Created successfully', resp.availabilities));
    } catch (e) {
      emit(AvailabilityFailure(e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdateAvailability event, Emitter<AvailabilityState> emit) async {
    emit(const AvailabilityLoadInProgress());
    try {
      final resp =
      await repository.updateAvailability(event.id, event.data);
      emit(AvailabilityOperationSuccess(
          resp.message ?? 'Updated successfully', resp.availabilities));
    } catch (e) {
      emit(AvailabilityFailure(e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteAvailability event, Emitter<AvailabilityState> emit) async {
    emit(const AvailabilityLoadInProgress());
    try {
      final message = await repository.deleteAvailability(event.id);
      // reload fresh list afterwards
      final list = await repository.getAvailabilities();
      emit(AvailabilityOperationSuccess(message, list));
    } catch (e) {
      emit(AvailabilityFailure(e.toString()));
    }
  }
}
