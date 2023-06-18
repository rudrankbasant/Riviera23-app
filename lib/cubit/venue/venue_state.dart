part of './venue_cubit.dart';

abstract class VenueState extends Equatable {
  const VenueState();

  @override
  List<Object> get props => [];
}

class VenueLoading extends VenueState {}

class VenueSuccess extends VenueState {
  final List<Venue> venuesList;

  const VenueSuccess({required this.venuesList});

  @override
  List<Object> get props => [venuesList];
}

class VenueFailed extends VenueState {
  final String error;

  const VenueFailed({required this.error});
}
