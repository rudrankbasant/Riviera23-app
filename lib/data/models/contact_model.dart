class ContactList {
  List<Contact> contactList;

  ContactList({required this.contactList});

  factory ContactList.fromMap(Map<String, dynamic> map) {
    List<Contact> mContactList = [];
    map['contacts'].forEach((v) {
      mContactList.add(Contact.fromMap(v));
    });
    return ContactList(contactList: mContactList);
  }
}

class Contact {
  final int id;
  final String name;
  final String designation;
  final String? phone;
  final String email;

  Contact({
    required this.id,
    required this.name,
    required this.designation,
    this.phone,
    required this.email,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      designation: map['designation'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}
