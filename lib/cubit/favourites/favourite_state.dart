part of './favourite_cubit.dart';

abstract class FavouriteState extends Equatable {
  const FavouriteState();

  @override
  List<Object> get props => [];
}

class FavouriteLoading extends FavouriteState {}

class FavouriteSuccess extends FavouriteState {
  final FavouriteModel favouriteList;

  const FavouriteSuccess({required this.favouriteList});

  @override
  List<Object> get props => [favouriteList];
}

class FavouriteFailed extends FavouriteState {
  final String error;

  const FavouriteFailed({required this.error});
}
