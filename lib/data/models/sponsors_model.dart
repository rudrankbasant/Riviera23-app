class SponsorsList {
  List<Sponsor> sponsorsList;

  SponsorsList({required this.sponsorsList});

  factory SponsorsList.fromMap(Map<String, dynamic> map) {
    List<Sponsor> mSponsorList = [];
    map['sponsors'].forEach((v) {
      mSponsorList.add(Sponsor.fromMap(v));
    });
    return SponsorsList(sponsorsList: mSponsorList);
  }
}

class Sponsor {
  final int id;
  final String name;
  final String? url;

  Sponsor({
    required this.id,
    required this.name,
    this.url,
  });

  factory Sponsor.fromMap(Map<String, dynamic> map) {
    return Sponsor(
      id: map['id'],
      name: map['name'],
      url: map['url'],
    );
  }
}
