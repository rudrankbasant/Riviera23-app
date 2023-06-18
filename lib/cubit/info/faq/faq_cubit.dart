import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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

      debugPrint(data.toString());
      FaqList faqListModel = FaqList.fromMap(data);

      emit(FaqSuccess(faqList: faqListModel.faqList));
    } catch (e) {
      emit(FaqFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remoteFAQVersion = prefs.getInt("remote_faq");
    int? localFAQVersion = prefs.getInt("local_faq");

    if (remoteFAQVersion != null) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        if (localFAQVersion != null) {
          if (remoteFAQVersion == localFAQVersion) {
            print("FAQs serverORCache is set to cache");
            return Source.cache;
          } else {
            print("FAQs was not up to date, serverORCache is set to server");
            prefs.setInt("local_faq", remoteFAQVersion);
            return Source.server;
          }
        } else {
          print(
              "local_faq was not even set up, serverORCache is set to server");
          prefs.setInt("local_faq", remoteFAQVersion);
          return Source.server;
        }
      } else {
        print("No internet connection, faq serverORCache is set to cache");
        return Source.cache;
      }
    } else {
      return Source.server;
    }
  }
}
