import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/events/events_cubit.dart';

import '../../cubit/events/events_state.dart';

class AllEvents extends StatefulWidget {
  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventsCubit>(context).getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventsCubit(),
        ),
      ],
      child: BlocConsumer<EventsCubit, EventsState>(
        listener: (context, state) {
          if (state is EventsError) {
            debugPrint("Errorr");
          }
          if (state is EventsSuccess) {
            debugPrint("Success");
          }
          if (state is EventsLoading) {
            debugPrint("Loading");
          }
        },
        builder:  (context, state) {
          if (state is EventsSuccess) {
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Text(state.events[index].name.toString()),
                    ],
                  ),
                );
              },
            );
          } else if (state is EventsError) {
            return Center(
              child: Text("errorrrr"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
    );
  }
}
