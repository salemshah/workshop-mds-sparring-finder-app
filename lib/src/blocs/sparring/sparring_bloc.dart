import 'package:bloc/bloc.dart';
import 'package:sparring_finder/src/repositories/sparring_repository.dart';
import 'sparring_event.dart';
import 'sparring_state.dart';

class SparringBloc extends Bloc<SparringEvent, SparringState> {
  final SparringRepository repository;

  SparringBloc({required this.repository}) : super(const SparringInitial()) {
    on<LoadSparrings>(_onLoadAll);
    on<LoadSparringById>(_onLoadOne);
    on<CreateSparring>(_onCreate);
    on<UpdateSparring>(_onUpdate);
    on<ConfirmSparring>(_onConfirm);
    on<CancelSparring>(_onCancel);
  }

  /* --------------------------- Handlers --------------------------- */

  // -------------------------------------------------------------------------
  // GET /sparring — get all sparrings for current user
  // -------------------------------------------------------------------------
  Future<void> _onLoadAll(
      LoadSparrings event, Emitter<SparringState> emit) async {
    emit(const SparringLoadInProgress());
    try {
      final list = await repository.getSparrings();
      emit(SparringLoadSuccess(list));
    } catch (e) {
      emit(SparringFailure(e.toString()));
    }
  }

  // -------------------------------------------------------------------------
  // GET /sparring/:id — get a single sparring
  // -------------------------------------------------------------------------
  Future<void> _onLoadOne(
      LoadSparringById event, Emitter<SparringState> emit) async {
    emit(const SparringLoadInProgress());
    try {
      final sparring = await repository.getSparringById(event.id);
      if (sparring == null) {
        emit(const SparringFailure('Sparring not found'));
      } else {
        emit(SparringSingleSuccess(sparring));
      }
    } catch (e) {
      emit(SparringFailure(e.toString()));
    }
  }

  // -------------------------------------------------------------------------
  // POST /sparring — create a sparring
  // -------------------------------------------------------------------------
  Future<void> _onCreate(
      CreateSparring event, Emitter<SparringState> emit) async {
    emit(const SparringLoadInProgress());
    try {
      final resp = await repository.createSparring(event.data);
      emit(SparringOperationSuccess(
          resp.message ?? 'Created successfully', resp.sparrings));
    } catch (e) {
      emit(SparringFailure(e.toString()));
    }
  }

  // -------------------------------------------------------------------------
  // PUT /sparring/:id — update a sparring
  // -------------------------------------------------------------------------
  Future<void> _onUpdate(
      UpdateSparring event, Emitter<SparringState> emit) async {
    emit(const SparringLoadInProgress());
    try {
      final resp = await repository.updateSparring(event.id, event.data);
      emit(SparringOperationSuccess(
          resp.message ?? 'Updated successfully', resp.sparrings));
    } catch (e) {
      emit(SparringFailure(e.toString()));
    }
  }

  // -------------------------------------------------------------------------
  // POST /sparring/:id/confirm — confirm a sparring
  // -------------------------------------------------------------------------
  Future<void> _onConfirm(
      ConfirmSparring event, Emitter<SparringState> emit) async {
    emit(const SparringLoadInProgress());
    try {
      final resp = await repository.confirmSparring(event.id);
      emit(SparringOperationSuccess(
          resp.message ?? 'Confirmed successfully', resp.sparrings));
    } catch (e) {
      emit(SparringFailure(e.toString()));
    }
  }

  // -------------------------------------------------------------------------
  // POST /sparring/:id/cancel — cancel a sparring
  // -------------------------------------------------------------------------
  Future<void> _onCancel(
      CancelSparring event, Emitter<SparringState> emit) async {
    emit(const SparringLoadInProgress());
    try {
      final resp = await repository.cancelSparring(event.id, event.data);
      emit(SparringOperationSuccess(
          resp.message ?? 'Cancelled successfully', resp.sparrings));
    } catch (e) {
      emit(SparringFailure(e.toString()));
    }
  }
}
