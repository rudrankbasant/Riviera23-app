class VenueList {
  final List<Venue> allVenues;

  VenueList({
    required this.allVenues,
  });

  factory VenueList.fromMap(Map<String, dynamic> map) {
    List<Venue> mVenueList = [];
    map['venues'].forEach((v) {
      mVenueList.add(Venue.fromMap(v));
    });
    return VenueList(allVenues: mVenueList);
  }
}

class Venue {
  final String venueName;
  final List<String> venueIds;
  final double latitude;
  final double longitude;

  Venue({
    required this.venueName,
    required this.venueIds,
    required this.latitude,
    required this.longitude,
  });

  factory Venue.fromMap(Map<String, dynamic> data) {
    return Venue(
      venueName: data['venue_name'],
      venueIds: List<String>.from(data['venue_ids']),
      latitude: data['lat'],
      longitude: data['long'],
    );
  }
}
