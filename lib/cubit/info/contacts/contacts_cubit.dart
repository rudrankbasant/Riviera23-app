import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/contact_model.dart';
part './contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsLoading()) {
    loadContacts();
  }

  void loadContacts() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot =
      await firestore.collection('contacts').doc('LTBXtL4ML3ptl6LGbK9y').get();
      Map<String, dynamic> data =
      timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint(data.toString());
      ContactList contactsListModel = ContactList.fromMap(data);

      emit(ContactsSuccess(contactsList: contactsListModel.contactList));
    } catch (e) {
      emit(ContactsFailed(error: e.toString()));
    }
  }
}
