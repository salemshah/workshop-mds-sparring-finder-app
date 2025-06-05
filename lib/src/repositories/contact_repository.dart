import 'package:sparring_finder/src/models/contact/contact_model.dart';
import 'package:sparring_finder/src/repositories/base_repository.dart';


class ContactRepository extends BaseRepository {
  ContactRepository({required super.apiService});

 

  // ----------------------------- CONTACT ---------------------------------- //
  /// POST `/contact` — Create a contact message.
  Future<Contact> createContact(Map<String, dynamic> data) async {
     final response = await apiService.post('/contact', data);
    return Contact.fromJson(response);
  }
}
