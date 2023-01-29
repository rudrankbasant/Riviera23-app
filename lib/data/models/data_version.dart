class DataVersion {
  final String app_version_number;
  final int announcement_version_number;
  final int contacts_version_number;
  final int faq_version_number;
  final int favorites_version_number;
  final int places_version_number;
  final int sponsors_version_number;
  final int team_version_number;

  DataVersion({
    required this.app_version_number,
    required this.announcement_version_number,
    required this.contacts_version_number,
    required this.faq_version_number,
    required this.favorites_version_number,
    required this.places_version_number,
    required this.sponsors_version_number,
    required this.team_version_number,
  });

  factory DataVersion.fromMap(Map<String, dynamic> map) {
    return DataVersion(
      app_version_number: map['app_version_number'],
      announcement_version_number: map['announcement_version_number'],
      contacts_version_number: map['contacts_version_number'],
      faq_version_number: map['faq_version_number'],
      favorites_version_number: map['favorites_version_number'],
      places_version_number: map['places_version_number'],
      sponsors_version_number: map['sponsors_version_number'],
      team_version_number: map['team_version_number'],
    );
  }
}
