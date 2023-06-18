import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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

      debugPrint(data.toString());
      VenueList venueListModel = VenueList.fromMap(data);

      emit(VenueSuccess(venuesList: venueListModel.allVenues));

/*      debugPrint(querySnapshot.toString());
      VenueList venueListModel = VenueList.fromsMap(querySnapshot.docs);
      print("here is the result ${venueListModel.allVenues}");
      emit(VenueSuccess(venuesList: venueListModel.allVenues));*/
    } catch (e) {
      print("VENUE ERROR " + e.toString());
      emit(VenueFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remotePlacesVersion = prefs.getInt("remote_places");
    int? localPlacesVersion = prefs.getInt("local_places");

    print("remotePlacesVersion $remotePlacesVersion");
    print("localPlacesVersion $localPlacesVersion");
    if (remotePlacesVersion != null) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        if (localPlacesVersion != null) {
          if (remotePlacesVersion == localPlacesVersion) {
            print("Places serverORCache is set to cache");
            return Source.cache;
          } else {
            print("Places was not up to date, serverORCache is set to server");
            prefs.setInt("local_places", remotePlacesVersion);
            return Source.server;
          }
        } else {
          print(
              "local_places was not even set up, serverORCache is set to server");
          prefs.setInt("local_places", remotePlacesVersion);
          return Source.server;
        }
      } else {
        print("No internet connection, venue serverORCache is set to cache");
        return Source.cache;
      }
    } else {
      return Source.server;
    }
  }
}
