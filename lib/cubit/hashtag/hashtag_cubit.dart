import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/Hashtag/Hashtag_state.dart';

import '../../data/repository/hashtag_repository.dart';

class HashtagCubit extends Cubit<HashtagState> {
  final HashtagRepository hashtagRepository;

  HashtagCubit(this.hashtagRepository) : super(InitHashtagState());

  void getAllHashtag() async {
    emit(HashtagLoading());
    try {
      final allHashtag = await hashtagRepository.getAllHashtag();
      emit(HashtagSuccess(allHashtag));
    } catch (e) {
      emit(HashtagError(e.toString()));
    }
  }
}
