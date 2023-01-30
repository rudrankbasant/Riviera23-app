import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/contact_model.dart';

part './contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsLoading()) {
    loadContacts();
  }

  void loadContacts() async {
    Source serverORcache = await _getSourceValue();
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection('contacts')
          .doc('LTBXtL4ML3ptl6LGbK9y')
          .get(GetOptions(source: serverORcache));
      Map<String, dynamic> data =
          timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint(data.toString());

      ContactList contactsListModel = ContactList.fromMap(data);

      debugPrint(contactsListModel.toString());
      emit(ContactsSuccess(contactsList: contactsListModel.contactList));
    } catch (e) {
      emit(ContactsFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remoteContactVersion = prefs.getInt("remote_contacts");
    int? localContactVersion = prefs.getInt("local_contacts");

    if (remoteContactVersion != null) {
      if (localContactVersion != null) {
        if (remoteContactVersion == localContactVersion) {
          print("Contacts serverORCache is set to cache");
          return Source.cache;
        } else {
          print("Contacts was not up to date, serverORCache is set to server");
          prefs.setInt("local_contacts", remoteContactVersion);
          return Source.server;
        }
      } else {
        print(
            "local_contacts was not even set up, serverORCache is set to server");
        prefs.setInt("local_contacts", remoteContactVersion);
        return Source.server;
      }
    } else {
      return Source.server;
    }
  }
}
