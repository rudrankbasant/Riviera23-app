import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

      DocumentSnapshot timelineSnapshot =
          await firestore.collection('team').doc('ADZSQgGgJMVbSOEfxgwQ').get(GetOptions(source: serverORcache));
      Map<String, dynamic> data =
          timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint(data.toString());
      TeamMemberList teamListModel = TeamMemberList.fromMap(data);

      emit(TeamSuccess(teamList: teamListModel.teamMemberList));
    } catch (e) {
      emit(TeamFailed(error: e.toString()));
    }
  }


  Future<Source> _getSourceValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remoteTeamVersion = prefs.getInt("remote_team");
    int? localTeamVersion = prefs.getInt("local_team");

    if(remoteTeamVersion!=null){
      if(localTeamVersion!=null){
        if(remoteTeamVersion==localTeamVersion){
          print("Teams serverORCache is set to cache");
          return Source.cache;
        }else{
          print("Teams was not up to date, serverORCache is set to server");
          prefs.setInt("local_team", remoteTeamVersion);
          return Source.server;
        }
      }else{
        print("local_team was not even set up, serverORCache is set to server");
        prefs.setInt("local_team", remoteTeamVersion);
        return Source.server;
      }
    }else{
      return Source.server;
    }

  }
}
