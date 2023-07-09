import '../../data/models/event_model.dart';
import '../../data/models/venue_model.dart';

Venue getVenue(List<Venue> allVenues, EventModel event) {
  for (final i in allVenues) {
    for (final j in i.venueIds) {
      if (event.loc.toString().toUpperCase().startsWith(j.toUpperCase())) {
        return i;
      }
    }
  }
  return Venue(
    venueName: "",
    venueIds: [""],
    latitude: 12.968731758988895,
    longitude: 79.15571764034306,
  );
}
