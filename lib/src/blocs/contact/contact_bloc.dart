import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/contact/contact_state.dart';
import 'package:sparring_finder/src/blocs/contact/contact_event.dart';
import 'package:sparring_finder/src/repositories/contact_repository.dart';


class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository repository;

  ContactBloc({required this.repository}) : super(const ContactInitial()) {
    on<ContactCreated>(_onContactCreated);
  }
  Future<void> _onContactCreated(ContactCreated event, Emitter<ContactState> emit) async {
    emit(const ContactLoadInProgress());
    try {
      final response = await repository.createContact(event.data);
      emit(ContactLoadSuccess(response));
    } catch (e) {
      emit(ContactFailure(e.toString()));
    }
  }
}