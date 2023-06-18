import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riviera23/data/models/announcement_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/strings.dart';

part './announcements_state.dart';

class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  AnnouncementsCubit() : super(AnnouncementsLoading()) {
    loadAnnouncements();
  }

  void loadAnnouncements() async {
    Source serverORcache = await _getSourceValue();

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection(Strings.announcementCollection)
          .doc('lq7FACaQrVL4hO3cM6Iq')
          .get(GetOptions(source: serverORcache));

      Map<String, dynamic> data = timelineSnapshot.data() as Map<String, dynamic>;

      AnnouncementList announcementsListModel = AnnouncementList.fromMap(data);

      emit(AnnouncementsSuccess(
          announcementsList: announcementsListModel.announcementList));
    } catch (e) {
      emit(AnnouncementsFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remoteAnnouncementVersion = prefs.getInt(Strings.idRemoteAnnouncement);
    int? localAnnouncementVersion = prefs.getInt(Strings.idLocalAnnouncement);

    if (remoteAnnouncementVersion != null) {
      /*NOTE: Checking internet connection here is important because if the app is opened with internet connection (hence fetches all remote data versions)
      and then goes to announcement page for the first time  with no internet connection the app will have an issue because the localAnnouncementVersion
      will be null and will update itself to the remoteAnnouncementVersion and hence will never fetch until remote version is updated.
      This is the case with all firebase calls, namely - contacts, sponsors, timeline, announcements, faq, team, venue*/

      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        if (localAnnouncementVersion != null) {
          if (remoteAnnouncementVersion == localAnnouncementVersion) {
            return Source.cache;
          } else {
            prefs.setInt(Strings.idLocalAnnouncement, remoteAnnouncementVersion);
            return Source.server;
          }
        } else {
          prefs.setInt(Strings.idLocalAnnouncement, remoteAnnouncementVersion);
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
