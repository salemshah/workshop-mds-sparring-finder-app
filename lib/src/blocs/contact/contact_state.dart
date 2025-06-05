import 'package:equatable/equatable.dart';
import 'package:sparring_finder/src/models/contact/contact_model.dart';

// ---------------------------------------------------------------------------
// States related to the Contact feature.
// ---------------------------------------------------------------------------

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class ContactInitial extends ContactState {
  const ContactInitial();
}

class ContactLoadInProgress extends ContactState {
  const ContactLoadInProgress();
}

class ContactFailure extends ContactState {
  final String error;

  const ContactFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ContactLoadSuccess extends ContactState {
  final Contact contact;

  const ContactLoadSuccess(this.contact);

  @override
  List<Object?> get props => [contact];
}
