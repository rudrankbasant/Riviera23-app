part of './merch_cubit.dart';

abstract class MerchState extends Equatable {
  const MerchState();

  @override
  List<Object> get props => [];
}

class MerchLoading extends MerchState {}

class MerchSuccess extends MerchState {
  final List<Merch> merchsList;

  const MerchSuccess({required this.merchsList});

  @override
  List<Object> get props => [merchsList];
}

class MerchFailed extends MerchState {
  final String error;

  const MerchFailed({required this.error});
}
