import 'package:flutter/cupertino.dart';

class FavouriteEvents extends StatefulWidget {
  String? eventsSearchQuery;

  FavouriteEvents(String eventsSearchQuery);

  @override
  State<FavouriteEvents> createState() => _FavouriteEventsState();
}

class _FavouriteEventsState extends State<FavouriteEvents> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Favourite"));
  }
}
