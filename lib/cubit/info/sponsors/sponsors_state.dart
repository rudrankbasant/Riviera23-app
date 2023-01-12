part of 'sponsors_cubit.dart';

abstract class SponsorsState extends Equatable {
  const SponsorsState();

  @override
  List<Object> get props => [];
}

class SponsorsLoading extends SponsorsState {}

class SponsorsSuccess extends SponsorsState {
  final List<Sponsor> sponsorsList;

  SponsorsSuccess({required this.sponsorsList});

  @override
  List<Object> get props => [SponsorsList];
}

class SponsorsFailed extends SponsorsState {
  final String error;

  SponsorsFailed({required this.error});
}
