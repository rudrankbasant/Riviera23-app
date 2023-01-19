import '../../data/models/event_model.dart';
import '../../data/models/venue_model.dart';

Venue getVenue(List<Venue> allVenues, EventModel event) {
  for(final i in allVenues){
    for(final j in i.venue_ids){
      print(j);
      if(j == event.loc.toString().toUpperCase()){
        return i;
      }
    }
  }
  return Venue(venue_name:"", venue_ids: [""], latitude: 12.968731758988895, longitude: 79.15571764034306,);
}