import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/proshows/proshows_state.dart';

import '../../data/repository/proshows_repository.dart';

class ProShowsCubit extends Cubit<ProShowsState> {
  final ProShowsRepository proshowsRepository;

  ProShowsCubit(this.proshowsRepository) : super(InitProShowsState());

  void getAllProShows() async {
    emit(ProShowsLoading());
    try {
      final allProShows = await proshowsRepository.getAllProShows();
      emit(ProShowsSuccess(allProShows));
    } catch (e) {
      emit(ProShowsError(e.toString()));
    }
  }
}
