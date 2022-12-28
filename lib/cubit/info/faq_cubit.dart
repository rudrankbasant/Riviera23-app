import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/faq_model.dart';

part 'faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  FaqCubit() : super(FaqLoading()) {
    loadFaq();
  }

  void loadFaq() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot =
          await firestore.collection('faqs').doc('rtYbV3P8UboH8HWhZAGC').get();
      Map<String, dynamic> data = timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint(data.toString());
      FaqList faqListModel = FaqList.fromMap(data);

      emit(FaqSuccess(faqList: faqListModel.faqList));
    } catch (e) {
      emit(FaqFailed(error: e.toString()));
    }
  }
}
