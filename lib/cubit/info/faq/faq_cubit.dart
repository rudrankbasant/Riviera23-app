import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/cubit_utils/get_source.dart';

import '../../../data/models/faq_model.dart';
import '../../../utils/constants/strings/shared_pref_keys.dart';

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
    return getSource(SharedPrefKeys.idLocalFaq, SharedPrefKeys.idRemoteFaq);
  }
}
