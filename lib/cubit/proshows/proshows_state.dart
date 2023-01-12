import 'package:equatable/equatable.dart';
import 'package:riviera23/data/models/event_model.dart';

abstract class ProShowsState extends Equatable {
  const ProShowsState();

  @override
  List<Object> get props => [];
}

class InitProShowsState extends ProShowsState {}

class ProShowsLoading extends ProShowsState {}

class ProShowsSuccess extends ProShowsState {
  List<EventModel> proShows;

  ProShowsSuccess(this.proShows);

  @override
  List<Object> get props => [this.proShows];
}

class ProShowsError extends ProShowsState {
  final String error;

  ProShowsError(this.error);

  @override
  List<Object> get props => [error];
}
