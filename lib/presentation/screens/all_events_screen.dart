import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/events/events_cubit.dart';

import '../../cubit/events/events_state.dart';
import '../../data/models/event_model.dart';
import '../methods/parse_datetime.dart';

class AllEvents extends StatefulWidget {
  String? eventsSearchQuery;

  AllEvents(String eventsSearchQuery);

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  List<EventModel> filteredEvents = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(builder: (context, state) {
      if (state is EventsSuccess) {
        List<EventModel> filteredEvents = state.events;

        debugPrint("--- and----" + filteredEvents.length.toString());
        return ListView.builder(
          itemCount: filteredEvents.length,
          itemBuilder: (context, index) {
            EventModel event = filteredEvents[index];
            return Card(
              child: Row(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.height * 0.1,
                      child: Image.network(
                        "https://i.ytimg.com/vi/v2gseMj1UGI/maxresdefault.jpg",
                        fit: BoxFit.cover,
                      )),
                  Column(
                    children: [
                      Text(event.name.toString()),
                      Text(parseDate(event.start))
                    ],
                  )
                ],
              ),
            );
          },
        );
      } else if (state is EventsError) {
        return const Center(
          child: Text("Error! Couldn't load."),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}