import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

      debugPrint(data.toString());
      SponsorsList sponsorsListModel = SponsorsList.fromMap(data);

      emit(SponsorsSuccess(sponsorsList: sponsorsListModel.sponsorsList));
    } catch (e) {
      emit(SponsorsFailed(error: e.toString()));
    }
  }
}

Future<Source> _getSourceValue() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int? remoteSponsorVersion = prefs.getInt("remote_sponsors");
  int? localSponsorVersion = prefs.getInt("local_sponsors");

  if (remoteSponsorVersion != null) {
    if (localSponsorVersion != null) {
      if (remoteSponsorVersion == localSponsorVersion) {
        print("Sponsors serverORCache is set to cache");
        return Source.cache;
      } else {
        print("Sponsors was not up to date, serverORCache is set to server");
        prefs.setInt("local_sponsors", remoteSponsorVersion);
        return Source.server;
      }
    } else {
      print(
          "local_sponsors was not even set up, serverORCache is set to server");
      prefs.setInt("local_sponsors", remoteSponsorVersion);
      return Source.server;
    }
  } else {
    return Source.server;
  }
}
