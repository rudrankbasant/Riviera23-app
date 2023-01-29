import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/data/models/announcement_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          .collection('announcements')
          .doc('lq7FACaQrVL4hO3cM6Iq')
          .get(GetOptions(source: serverORcache));

      Map<String, dynamic> data =
          timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint("this is data" + data.toString());
      AnnouncementList announcementsListModel = AnnouncementList.fromMap(data);

      emit(AnnouncementsSuccess(
          announcementsList: announcementsListModel.announcementList));
    } catch (e) {
      emit(AnnouncementsFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remoteAnnouncementVersion = prefs.getInt("remote_announcement");
    int? localAnnouncementVersion = prefs.getInt("local_announcement");

    if (remoteAnnouncementVersion != null) {
      if (localAnnouncementVersion != null) {
        if (remoteAnnouncementVersion == localAnnouncementVersion) {
          print("Announcement serverORCache is set to cache");
          return Source.cache;
        } else {
          print(
              "Announcement was not up to date, serverORCache is set to server");
          prefs.setInt("local_announcement", remoteAnnouncementVersion);
          return Source.server;
        }
      } else {
        print(
            "local_announcement was not even set up, serverORCache is set to server");
        prefs.setInt("local_announcement", remoteAnnouncementVersion);
        return Source.server;
      }
    } else {
      return Source.server;
    }
  }
}
