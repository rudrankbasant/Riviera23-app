part of './team_cubit.dart';



abstract class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object> get props => [];
}

class TeamLoading extends TeamState {}

class TeamSuccess extends TeamState {
  final List<TeamMember> teamList;

  TeamSuccess({required this.teamList});

  @override
  List<Object> get props => [teamList];
}

class TeamFailed extends TeamState {
  final String error;

  TeamFailed({required this.error});
}
