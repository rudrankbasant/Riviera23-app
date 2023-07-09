import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/data/models/team_member_model.dart';

import '../../../utils/constants/strings/shared_pref_keys.dart';
import '../../cubit_utils/get_source.dart';

part './team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(TeamLoading()) {
    loadTeam();
  }

  void loadTeam() async {
    Source serverORcache = await _getSourceValue();
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection('team')
          .doc('ADZSQgGgJMVbSOEfxgwQ')
          .get(GetOptions(source: serverORcache));
      Map<String, dynamic> data =
          timelineSnapshot.data() as Map<String, dynamic>;

      TeamMemberList teamListModel = TeamMemberList.fromMap(data);

      emit(TeamSuccess(teamList: teamListModel.teamMemberList));
    } catch (e) {
      emit(TeamFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    return getSource(SharedPrefKeys.idLocalTeam, SharedPrefKeys.idRemoteTeam);
  }
}
