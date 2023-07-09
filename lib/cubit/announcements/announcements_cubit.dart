import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/cubit_utils/get_source.dart';
import 'package:riviera23/data/models/announcement_model.dart';

import '../../utils/constants/strings/shared_pref_keys.dart';
import '../../utils/constants/strings/strings.dart';

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

      emit(AnnouncementsSuccess(announcementsList: announcementsListModel.announcementList));
    } catch (e) {
      emit(AnnouncementsFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    return getSource(SharedPrefKeys.idLocalAnnouncement, SharedPrefKeys.idRemoteAnnouncement);
  }
}
