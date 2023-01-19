import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/data/models/announcement_model.dart';

part './announcements_state.dart';

class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  AnnouncementsCubit() : super(AnnouncementsLoading()) {
    loadAnnouncements();
  }

  void loadAnnouncements() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection('announcements')
          .doc('lq7FACaQrVL4hO3cM6Iq')
          .get();

      Map<String, dynamic> data = timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint("this is data" + data.toString());
      AnnouncementList announcementsListModel = AnnouncementList.fromMap(data);

      emit(AnnouncementsSuccess(announcementsList: announcementsListModel.announcementList));
    } catch (e) {
      emit(AnnouncementsFailed(error: e.toString()));
    }
  }
}
