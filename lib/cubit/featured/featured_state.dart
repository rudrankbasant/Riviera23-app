import 'package:equatable/equatable.dart';
import 'package:riviera23/data/models/event_model.dart';

abstract class FeaturedState extends Equatable {
  const FeaturedState();

  @override
  List<Object> get props => [];
}

class InitFeaturedState extends FeaturedState {}

class FeaturedLoading extends FeaturedState {}

class FeaturedSuccess extends FeaturedState {
  List<EventModel> featured;

  FeaturedSuccess(this.featured);

  @override
  List<Object> get props => [this.featured];
}

class FeaturedError extends FeaturedState {
  final String error;

  FeaturedError(this.error);

  @override
  List<Object> get props => [error];
}
