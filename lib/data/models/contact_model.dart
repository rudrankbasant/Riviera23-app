class ContactList {
  List<Contact> contactList;

  ContactList({required this.contactList});

  factory ContactList.fromMap(Map<String, dynamic> map) {
    List<Contact> mContactList = [];
    map['Contacts'].forEach((v) {
      mContactList.add(Contact.fromMap(v));
    });
    return ContactList(contactList: mContactList);
  }
}

class Contact {
  final int id;
  final String question;
  final String answer;

  Contact({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
    );
  }
}
