import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riviera23/constants/strings/shared_pref_keys.dart';
import 'package:riviera23/data/models/sponsors_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sponsors_state.dart';

class SponsorsCubit extends Cubit<SponsorsState> {
  SponsorsCubit() : super(SponsorsLoading()) {
    loadSponsors();
  }

  void loadSponsors() async {
    Source serverORcache = await _getSourceValue();

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection('sponsors')
          .doc('KacMT6fDwjQyvYWtU0EP')
          .get(GetOptions(source: serverORcache));

      Map<String, dynamic> data =
          timelineSnapshot.data() as Map<String, dynamic>;

      SponsorsList sponsorsListModel = SponsorsList.fromMap(data);

      emit(SponsorsSuccess(sponsorsList: sponsorsListModel.sponsorsList));
    } catch (e) {
      emit(SponsorsFailed(error: e.toString()));
    }
  }
}

Future<Source> _getSourceValue() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int? remoteSponsorVersion = prefs.getInt(SharedPrefKeys.idRemoteSponsors);
  int? localSponsorVersion = prefs.getInt(SharedPrefKeys.idLocalSponsors);

  if (remoteSponsorVersion != null) {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      if (localSponsorVersion != null) {
        if (remoteSponsorVersion == localSponsorVersion) {
          return Source.cache;
        } else {
          prefs.setInt(SharedPrefKeys.idLocalSponsors, remoteSponsorVersion);
          return Source.server;
        }
      } else {
        prefs.setInt(SharedPrefKeys.idLocalSponsors, remoteSponsorVersion);
        return Source.server;
      }
    } else {
      return Source.cache;
    }
  } else {
    return Source.server;
  }
}
