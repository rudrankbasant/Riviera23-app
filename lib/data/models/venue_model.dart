import 'package:flutter/cupertino.dart';

class VenueList {
  final List<Venue> allVenues;

  VenueList({
    required this.allVenues,
  });

  factory VenueList.fromMap(Map<String, dynamic> map) {
    List<Venue> mVenueList = [];
    map['venues'].forEach((v) {
      debugPrint('Venue List EACH = $v');
      mVenueList.add(Venue.fromMap(v));
    });
    return VenueList(allVenues: mVenueList);
  }

/*factory VenueList.fromsSnapshots(List<QueryDocumentSnapshot> snapshots){
    List<Venue> mVenues = [];
    snapshots.forEach((v) {
      mVenues.add(Venue.fromMap(v.data()));
    });
    return VenueList(allVenues: mVenues);
  }*/
/* factory VenueList.fromsSnapshots(List<QueryDocumentSnapshot<Object?>> docs) {
    print("VenueList.fromsSnapshots started $docs");
    List<Venue> venues = [];
    docs.forEach((doc) {
      venues.add(Venue.fromSnaps(doc.data() as Map<String, dynamic>));
    });
    print("VenueList.fromsSnapshots ended $venues");
    return VenueList(allVenues: venues);
  }*/
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
    print("Venue.fromSnaps started $data");
    return Venue(
      venue_name: data['venue_name'],
      venue_ids: List<String>.from(data['venue_ids']),
      latitude: data['lat'],
      longitude: data['long'],
    );
  }
/*  factory Venue.fromSnaps(Map<String, dynamic> data) {
    print("Venue.fromSnaps started $data");
    return Venue(
      venue_name: data['venue_name'],
      venue_ids: List<String>.from(data['venue_ids']),
      latitude: data['lat'],
      longitude: data['long'],
    );
  }*/
}
