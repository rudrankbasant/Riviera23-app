import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/cubit_utils/get_source.dart';
import '../../data/models/merch_model.dart';
import '../../utils/constants/strings/shared_pref_keys.dart';

part './merch_state.dart';

class MerchCubit extends Cubit<MerchState> {
  MerchCubit() : super(MerchLoading()) {
    loadMerch();
  }

  void loadMerch() async {
    Source serverORcache = await _getSourceValue();

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection('merch')
          .doc('tnD9TzV0iVoq77moYpIl')
          .get(GetOptions(source: serverORcache));
      Map<String, dynamic> data = timelineSnapshot.data() as Map<String, dynamic>;

      MerchList merchListModel = MerchList.fromMap(data);

      emit(MerchSuccess(merchsList: merchListModel.merchList));
    } catch (e) {
      emit(MerchFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    return getSource(SharedPrefKeys.idLocalMerch, SharedPrefKeys.idRemoteMerch);
  }
}
