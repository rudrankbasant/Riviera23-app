part of './faq_cubit.dart';

abstract class FaqState extends Equatable {
  const FaqState();

  @override
  List<Object> get props => [];
}

class FaqLoading extends FaqState {}

class FaqSuccess extends FaqState {
  final List<Faq> faqList;

  FaqSuccess({required this.faqList});

  @override
  List<Object> get props => [faqList];
}

class FaqFailed extends FaqState {
  final String error;

  FaqFailed({required this.error});
}
