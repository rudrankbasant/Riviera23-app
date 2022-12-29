import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/data/models/team_member_model.dart';

part './team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(TeamLoading()) {
    loadTeam();
  }

  void loadTeam() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot =
      await firestore.collection('team').doc('ADZSQgGgJMVbSOEfxgwQ').get();
      Map<String, dynamic> data =
      timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint(data.toString());
      TeamMemberList teamListModel = TeamMemberList.fromMap(data);

      emit(TeamSuccess(teamList: teamListModel.teamMemberList));
    } catch (e) {
      emit(TeamFailed(error: e.toString()));
    }
  }
}
