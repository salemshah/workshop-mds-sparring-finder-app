import 'package:equatable/equatable.dart';


/// Core domain model for a fighter profile.
class Contact extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String subject;
  final String description;

  

  const Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.subject,
    required this.description,
  });

  /// Builds a [Contact] object from a JSON map returned by the API.
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as int,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  /// Converts a [Contact] instance back into a JSON map suitable for the API.
  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'subject': subject,
        'description': description,
      };

  /// Handy utility when your repository receives a list of raw contact.
  static List<Contact> listFromJson(List<dynamic> data) =>
      data.map((e) => Contact.fromJson(e as Map<String, dynamic>)).toList();

  Contact copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? subject,
    String? description,
  }) {
    return Contact(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        subject,
        description,
      ];
}
