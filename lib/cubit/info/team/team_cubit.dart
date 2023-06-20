import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riviera23/constants/strings/shared_pref_keys.dart';
import 'package:riviera23/data/models/team_member_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remoteTeamVersion = prefs.getInt(SharedPrefKeys.idRemoteTeam);
    int? localTeamVersion = prefs.getInt(SharedPrefKeys.idLocalTeam);

    if (remoteTeamVersion != null) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        if (localTeamVersion != null) {
          if (remoteTeamVersion == localTeamVersion) {
            return Source.cache;
          } else {
            prefs.setInt(SharedPrefKeys.idLocalTeam, remoteTeamVersion);
            return Source.server;
          }
        } else {
          prefs.setInt(SharedPrefKeys.idLocalTeam, remoteTeamVersion);
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
