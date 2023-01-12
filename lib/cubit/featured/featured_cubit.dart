import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/featured/featured_state.dart';

import '../../data/repository/featured_repository.dart';

class FeaturedCubit extends Cubit<FeaturedState> {
  final FeaturedRepository featuredRepository;

  FeaturedCubit(this.featuredRepository) : super(InitFeaturedState());

  void getAllFeatured() async {
    emit(FeaturedLoading());
    try {
      final allFeatured = await featuredRepository.getAllFeatured();
      emit(FeaturedSuccess(allFeatured));
    } catch (e) {
      emit(FeaturedError(e.toString()));
    }
  }
}
