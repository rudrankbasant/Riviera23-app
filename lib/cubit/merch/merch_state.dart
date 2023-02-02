part of './merch_cubit.dart';

abstract class MerchState extends Equatable {
  const MerchState();

  @override
  List<Object> get props => [];
}

class MerchLoading extends MerchState {}

class MerchSuccess extends MerchState {
  final List<Merch> merchsList;

  MerchSuccess({required this.merchsList});

  @override
  List<Object> get props => [merchsList];
}

class MerchFailed extends MerchState {
  final String error;

  MerchFailed({required this.error});
}
