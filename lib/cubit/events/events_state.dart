import 'package:equatable/equatable.dart';
import 'package:riviera23/data/models/event_model.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

class InitEventsState extends EventsState {}

class EventsLoading extends EventsState {}

class EventsSuccess extends EventsState {
  final List<EventModel> events;

  const EventsSuccess(this.events);

  @override
  List<Object> get props => [events];
}

class EventsError extends EventsState {
  final String error;

  const EventsError(this.error);

  @override
  List<Object> get props => [error];
}
