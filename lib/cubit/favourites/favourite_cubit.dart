import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/data/models/favourite_model.dart';

import '../../service/auth.dart';

part './favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteLoading()) {}

  void loadFavourites(User user) async {
    try {
      emit(FavouriteLoading());
      if (user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        DocumentSnapshot timelineSnapshot =
            await firestore.collection('favourites').doc(user.uid).get();
        if (timelineSnapshot.exists) {
          Map<String, dynamic> data =
              timelineSnapshot.data() as Map<String, dynamic>;
          debugPrint(user.uid + data.toString());
          debugPrint("---here debug--${FavouriteModel.fromMap(data)}");
          FavouriteModel userFavourites = FavouriteModel.fromMap(data);
          emit(FavouriteSuccess(favouriteList: userFavourites));
        } else {
          FavouriteModel userFavourites =
              FavouriteModel(uniqueUserId: user.uid, favouriteEventIds: []);
          upDateFavourites(userFavourites);
          emit(FavouriteSuccess(favouriteList: userFavourites));
        }
      } else {
        emit(FavouriteFailed(error: 'User not logged in'));
      }
    } catch (e) {
      emit(FavouriteFailed(error: e.toString()));
    }
  }

  upDateFavourites(FavouriteModel favouriteModel) async {
    try {
      emit(FavouriteLoading());
      final user = AuthService(FirebaseAuth.instance).user;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore
          .collection('favourites')
          .doc(user.uid)
          .set(favouriteModel.toMap())
          .then((_) => print('Added'))
          .catchError((error) => print('Add failed: $error'));
      print("-----here-----");
      //loadFavourites(user);
      emit(FavouriteSuccess(favouriteList: favouriteModel));
    } catch (e) {
      emit(FavouriteFailed(error: e.toString()));
    }
  }
}
