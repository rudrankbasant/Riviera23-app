import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/data/models/favourite_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_cubit.dart';

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
          FavouriteModel userFavourites = FavouriteModel.fromMap(data);
          syncExistingUsersToSubscribedTopics(userFavourites);
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
      final user = AuthCubit().user;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore
          .collection('favourites')
          .doc(user.uid)
          .set(favouriteModel.toMap())
          .then((_) => print('Added'))
          .catchError((error) => print('Add failed: $error'));
      //loadFavourites(user);
      emit(FavouriteSuccess(favouriteList: favouriteModel));
    } catch (e) {
      emit(FavouriteFailed(error: e.toString()));
    }
  }

  void syncExistingUsersToSubscribedTopics(
      FavouriteModel userFavourites) async {
    //this is a one time function to sync the existing users' favourites to the subscribed topics
    //so that they can receive notifications for their favourites

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? showcaseVisibilityStatus = prefs.getBool("subscribe_existing_users");

    if (showcaseVisibilityStatus == null) {
      prefs.setBool("subscribe_existing_users", false);
      print("subscribing existing users to topics");
      for (var favID in userFavourites.favouriteEventIds) {
        print("subscribe to topic: " + favID);
        await FirebaseMessaging.instance.subscribeToTopic(favID);
      }
    } else {
      print("already subscribed existing users to topics");
    }
  }
}
