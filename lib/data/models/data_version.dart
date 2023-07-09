class DataVersion {
  final String appVersionNumber;
  final int announcementVersionNumber;
  final int contactsVersionNumber;
  final int faqVersionNumber;
  final int favouritesVersionNumber;
  final int placesVersionNumber;
  final int sponsorsVersionNumber;
  final int teamVersionNumber;
  final int merchVersionNumber;

  DataVersion({
    required this.appVersionNumber,
    required this.announcementVersionNumber,
    required this.contactsVersionNumber,
    required this.faqVersionNumber,
    required this.favouritesVersionNumber,
    required this.placesVersionNumber,
    required this.sponsorsVersionNumber,
    required this.teamVersionNumber,
    required this.merchVersionNumber,
  });

  factory DataVersion.fromMap(Map<String, dynamic> map) {
    return DataVersion(
      appVersionNumber: map['app_version_number'],
      announcementVersionNumber: map['announcement_version_number'],
      contactsVersionNumber: map['contacts_version_number'],
      faqVersionNumber: map['faq_version_number'],
      favouritesVersionNumber: map['favourites_version_number'],
      placesVersionNumber: map['places_version_number'],
      sponsorsVersionNumber: map['sponsors_version_number'],
      teamVersionNumber: map['team_version_number'],
      merchVersionNumber: map['merch_version_number'],
    );
  }
}
