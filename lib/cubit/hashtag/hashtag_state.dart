import 'package:equatable/equatable.dart';
import 'package:riviera23/data/models/event_model.dart';
import 'package:riviera23/data/models/hashtag_model.dart';

abstract class HashtagState extends Equatable {
  const HashtagState();

  @override
  List<Object> get props => [];
}

class InitHashtagState extends HashtagState {}

class HashtagLoading extends HashtagState {}

class HashtagSuccess extends HashtagState {
  List<HashtagModel> hashtags;

  HashtagSuccess(this.hashtags);

  @override
  List<Object> get props => [this.hashtags];
}

class HashtagError extends HashtagState {
  final String error;

  HashtagError(this.error);

  @override
  List<Object> get props => [error];
}
