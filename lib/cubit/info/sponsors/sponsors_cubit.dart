import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/data/models/sponsors_model.dart';

part 'sponsors_state.dart';

class SponsorsCubit extends Cubit<SponsorsState> {
  SponsorsCubit() : super(SponsorsLoading()) {
    loadSponsors();
  }

  void loadSponsors() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection('sponsors')
          .doc('KacMT6fDwjQyvYWtU0EP')
          .get();

      Map<String, dynamic> data =
          timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint(data.toString());
      SponsorsList sponsorsListModel = SponsorsList.fromMap(data);

      emit(SponsorsSuccess(sponsorsList: sponsorsListModel.sponsorsList));
    } catch (e) {
      emit(SponsorsFailed(error: e.toString()));
    }
  }
}
