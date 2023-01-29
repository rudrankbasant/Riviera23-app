import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/data/models/data_version.dart';

part './version_state.dart';

class VersionCubit extends Cubit<VersionState> {

  VersionCubit() : super(VersionLoading()) {
   // getRemoteVersion();
  }

  void getRemoteVersion() async {
    /*try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot timelineSnapshot = await firestore
          .collection('dataversion')
          .doc('Si44DbMWkgcwGVcKcW54')
          .get();

      Map<String, dynamic> data =
      timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint("this is version data" + data.toString());
      DataVersion dataVersion = DataVersion.fromMap(data);

      emit(VersionSuccess(remoteVersion: dataVersion.data_version_number));
      return dataVersion.data_version_number;

    } catch (e) {
      emit(VersionFailed(error: e.toString()));
      print(e.toString());
      return -1;
    }*/
  }
}
