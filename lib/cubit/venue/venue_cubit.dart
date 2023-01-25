import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/venue_model.dart';

part './venue_state.dart';

class VenueCubit extends Cubit<VenueState> {
  VenueCubit() : super(VenueLoading()) {
    loadVenue();
  }

  void loadVenue() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore.collection('places').get();

      debugPrint(querySnapshot.toString());
      VenueList venueListModel = VenueList.fromsSnapshots(querySnapshot.docs);
      print("here is the result ${venueListModel.allVenues}");
      emit(VenueSuccess(venuesList: venueListModel.allVenues));
    } catch (e) {
      emit(VenueFailed(error: e.toString()));
    }
  }
}
