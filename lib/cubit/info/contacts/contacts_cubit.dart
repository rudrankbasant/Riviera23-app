import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riviera23/constants/strings/shared_pref_keys.dart';
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

      ContactList contactsListModel = ContactList.fromMap(data);

      emit(ContactsSuccess(contactsList: contactsListModel.contactList));
    } catch (e) {
      emit(ContactsFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remoteContactVersion = prefs.getInt(SharedPrefKeys.idRemoteContacts);
    int? localContactVersion = prefs.getInt(SharedPrefKeys.idLocalContacts);

    if (remoteContactVersion != null) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        if (localContactVersion != null) {
          if (remoteContactVersion == localContactVersion) {
            return Source.cache;
          } else {
            prefs.setInt(SharedPrefKeys.idLocalContacts, remoteContactVersion);
            return Source.server;
          }
        } else {
          prefs.setInt(SharedPrefKeys.idLocalContacts, remoteContactVersion);
          return Source.server;
        }
      } else {
        return Source.cache;
      }
    } else {
      return Source.server;
    }
  }
}
