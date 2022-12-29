class TeamMemberList {
  List<TeamMember> teamMemberList;

  TeamMemberList({required this.teamMemberList});

  factory TeamMemberList.fromMap(Map<String, dynamic> map) {
    List<TeamMember> mTeamMemberList = [];
    map['TeamMembers'].forEach((v) {
      mTeamMemberList.add(TeamMember.fromMap(v));
    });
    return TeamMemberList(teamMemberList: mTeamMemberList);
  }
}

class TeamMember {
  final int id;
  final String name;
  final String designation;
  final String url;

  TeamMember({
    required this.id,
    required this.name, required this.designation, required this.url,

  });

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      id: map['id'],
      name: map['name'],
      designation: map['designation'],
      url: map['url'],
    );
  }
}
