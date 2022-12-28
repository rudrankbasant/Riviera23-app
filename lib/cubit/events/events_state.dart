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

  EventsSuccess(this.events);

  @override
  List<Object> get props => [this.events];
}

class EventsError extends EventsState {
  final String error;

  EventsError(this.error);

  @override
  List<Object> get props => [error];
}
