import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/cubit_utils/get_source.dart';

import '../../data/models/venue_model.dart';
import '../../utils/constants/strings/shared_pref_keys.dart';

part './venue_state.dart';

class VenueCubit extends Cubit<VenueState> {
  VenueCubit() : super(VenueLoading()) {
    loadVenue();
  }

  void loadVenue() async {
    Source serverORcache = await _getSourceValue();

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection('venues')
          .doc('cwY2PXEoh4kV3VQyMxxH')
          .get(GetOptions(source: serverORcache));
      Map<String, dynamic> data =
          timelineSnapshot.data() as Map<String, dynamic>;

      VenueList venueListModel = VenueList.fromMap(data);

      emit(VenueSuccess(venuesList: venueListModel.allVenues));
    } catch (e) {
      emit(VenueFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    return getSource(SharedPrefKeys.idLocalPlaces, SharedPrefKeys.idRemotePlaces);
  }
}
