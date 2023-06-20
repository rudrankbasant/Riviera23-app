import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riviera23/constants/strings/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/venue_model.dart';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remotePlacesVersion = prefs.getInt(SharedPrefKeys.idRemotePlaces);
    int? localPlacesVersion = prefs.getInt(SharedPrefKeys.idLocalPlaces);

    if (remotePlacesVersion != null) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        if (localPlacesVersion != null) {
          if (remotePlacesVersion == localPlacesVersion) {
            return Source.cache;
          } else {
            prefs.setInt(SharedPrefKeys.idLocalPlaces, remotePlacesVersion);
            return Source.server;
          }
        } else {
          prefs.setInt(SharedPrefKeys.idLocalPlaces, remotePlacesVersion);
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
