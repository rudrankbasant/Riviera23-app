import '../../data/models/event_model.dart';
import '../../data/models/venue_model.dart';

Venue getVenue(List<Venue> allVenues, EventModel event) {
  for (final i in allVenues) {
    for (final j in i.venue_ids) {
      print("getVenue: ${i.venue_name} has $j  and ${event.loc.toString()}");
      if (event.loc.toString().toUpperCase().startsWith(j.toUpperCase())) {
        print("getVenue:  ${i.venue_name} has $j was returned");
        return i;
      }
    }
  }
  return Venue(
    venue_name: "",
    venue_ids: [""],
    latitude: 12.968731758988895,
    longitude: 79.15571764034306,
  );
}
