import 'package:equatable/equatable.dart';

// ---------------------------------------------------------------------------
// Events for managing the Contact feature.
// These events are dispatched by the UI to trigger actions in the BLoC.
// ---------------------------------------------------------------------------

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}



class ContactCreated extends ContactEvent {
  final Map<String, dynamic> data;

  const ContactCreated({required this.data});

  @override
  List<Object?> get props => [data];
}

