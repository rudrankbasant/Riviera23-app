part of 'sponsors_cubit.dart';

abstract class SponsorsState extends Equatable {
  const SponsorsState();

  @override
  List<Object> get props => [];
}

class SponsorsLoading extends SponsorsState {}

class SponsorsSuccess extends SponsorsState {
  final List<Sponsor> sponsorsList;

  const SponsorsSuccess({required this.sponsorsList});

  @override
  List<Object> get props => [SponsorsList];
}

class SponsorsFailed extends SponsorsState {
  final String error;

  const SponsorsFailed({required this.error});
}
