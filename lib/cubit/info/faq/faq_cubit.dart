import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riviera23/constants/strings/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/faq_model.dart';

part './faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  FaqCubit() : super(FaqLoading()) {
    loadFaq();
  }

  void loadFaq() async {
    Source serverORcache = await _getSourceValue();
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection('faqs')
          .doc('rtYbV3P8UboH8HWhZAGC')
          .get(GetOptions(source: serverORcache));
      Map<String, dynamic> data =
          timelineSnapshot.data() as Map<String, dynamic>;

      FaqList faqListModel = FaqList.fromMap(data);

      emit(FaqSuccess(faqList: faqListModel.faqList));
    } catch (e) {
      emit(FaqFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remoteFAQVersion = prefs.getInt(SharedPrefKeys.idRemoteFaq);
    int? localFAQVersion = prefs.getInt(SharedPrefKeys.idLocalFaq);

    if (remoteFAQVersion != null) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        if (localFAQVersion != null) {
          if (remoteFAQVersion == localFAQVersion) {
            return Source.cache;
          } else {
            prefs.setInt(SharedPrefKeys.idLocalFaq, remoteFAQVersion);
            return Source.server;
          }
        } else {
          prefs.setInt(SharedPrefKeys.idLocalFaq, remoteFAQVersion);
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
