import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/events/events_state.dart';

import '../../data/repository/events_repository.dart';

class EventsCubit extends Cubit<EventsState> {
  EventsCubit() : super(InitEventsState());

  void getAllEvents() async {


    emit(EventsLoading());
    try {
      final allEvents = await EventsRepository().getAllEvents();
      emit(EventsSuccess(allEvents));

    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }
}
