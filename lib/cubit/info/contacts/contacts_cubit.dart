import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/cubit_utils/get_source.dart';

import '../../../data/models/contact_model.dart';
import '../../../utils/constants/strings/shared_pref_keys.dart';

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
    return getSource( SharedPrefKeys.idLocalContacts, SharedPrefKeys.idRemoteContacts);
  }
}
