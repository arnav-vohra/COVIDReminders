import 'package:hello_world/models/index.dart';
import 'package:contact_picker/contact_picker.dart';

class ContactState {
  final Contact contact;

  ContactState({this.contact});

  factory ContactState.initial() {
    return new ContactState(contact: new Contact(fullName: ""));
  }

  static ContactState fromJson(dynamic json) {
    return json != null
        ? new ContactState(
            contact: new Contact(
                fullName: json["fullName"],
                phoneNumber: PhoneNumber.fromMap(json["phoneNumber"])))
        : null;
  }

  dynamic toJson() {
    return {
      'contact': {
        'fullName': this.contact.fullName,
        'phoneNumber': {
          'label': this.contact.phoneNumber.label,
          'number': this.contact.phoneNumber.number
        }
      }
    };
  }

  ContactState copyWith({Contact contact}) {
    return ContactState(contact: contact ?? this.contact);
  }
}
