import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/merch_model.dart';

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
      Map<String, dynamic> data =
      timelineSnapshot.data() as Map<String, dynamic>;

      debugPrint(data.toString());
      MerchList MerchListModel = MerchList.fromMap(data);

      emit(MerchSuccess(merchsList: MerchListModel.merchList));


    } catch (e) {
      print("Merch ERROR " + e.toString());
      emit(MerchFailed(error: e.toString()));
    }
  }

  Future<Source> _getSourceValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remoteMerchVersion = prefs.getInt("remote_merch");
    int? localMerchVersion = prefs.getInt("local_merch");

    print("remoteMerchVersion $remoteMerchVersion");
    print("localMerchVersion $localMerchVersion");
    if (remoteMerchVersion != null) {
      bool result = await InternetConnectionChecker().hasConnection;
      if(result == true) {
        if (localMerchVersion != null) {
          if (remoteMerchVersion == localMerchVersion) {
            print("Merch serverORCache is set to cache");
            return Source.cache;
          } else {
            print("Merch was not up to date, serverORCache is set to server");
            prefs.setInt("local_merch", remoteMerchVersion);
            return Source.server;
          }
        } else {
          print(
              "local_merch was not even set up, serverORCache is set to server");
          prefs.setInt("local_merch", remoteMerchVersion);
          return Source.server;
        }
      } else {
        print("No internet connection, Merch serverORCache is set to cache");
        return Source.cache;
      }
    } else {
      return Source.server;
    }
  }
}
