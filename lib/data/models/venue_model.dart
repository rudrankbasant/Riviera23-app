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
  final String venue_name;
  final List<String> venue_ids;
  final double latitude;
  final double longitude;

  Venue({
    required this.venue_name,
    required this.venue_ids,
    required this.latitude,
    required this.longitude,
  });

  factory Venue.fromMap(Map<String, dynamic> data) {
    return Venue(
      venue_name: data['venue_name'],
      venue_ids: List<String>.from(data['venue_ids']),
      latitude: data['lat'],
      longitude: data['long'],
    );
  }
}
