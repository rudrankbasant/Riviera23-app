import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/constants/strings/asset_paths.dart';
import 'package:riviera23/data/models/favourite_model.dart';
import 'package:riviera23/presentation/methods/parse_datetime.dart';
import 'package:riviera23/presentation/screens/home_screen.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:riviera23/utils/map_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../constants/strings/shared_pref_keys.dart';
import '../../constants/strings/strings.dart';
import '../../cubit/favourites/favourite_cubit.dart';
import '../../data/models/event_model.dart';
import '../../data/models/venue_model.dart';
import 'custom_flushbar.dart';
import 'launch_url.dart';

void showCustomBottomSheet(
    BuildContext context, EventModel event, Venue venue) {
  List<String> favouritesIDs = [];
  var isFavourite = false;

  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) => BlocBuilder<FavouriteCubit, FavouriteState>(
              builder: (context, state) {
            if (state is FavouriteSuccess || state is FavouriteLoading) {
              if (state is FavouriteSuccess) {
                favouritesIDs = state.favouriteList.favouriteEventIds;
                isFavourite = favouritesIDs.contains(event.id);
              }

              GlobalKey favouriteGuide = GlobalKey();

              return ShowCaseWidget(
                builder: Builder(builder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => displayEventCardShowcase(context, favouriteGuide));
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: AppColors.cardBgColor,
                    ),
                    height: MediaQuery.of(context).size.height * 0.92,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            height: 5,
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Stack(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (rect) {
                                      return const LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.center,
                                        colors: [
                                          Colors.black,
                                          Colors.transparent
                                        ],
                                      ).createShader(Rect.fromLTRB(
                                          0, 0, rect.width, rect.height));
                                    },
                                    blendMode: BlendMode.dstOut,
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: CachedNetworkImage(
                                          height: 250,
                                          width: 200,
                                          imageUrl: event.imageUrl.toString(),
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: AppColors.primaryColor,
                                            highlightColor: Colors.grey,
                                            child: Container(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  AssetPaths.placeholder),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Positioned(
                                    left: 0.0,
                                    bottom: 0.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        updateFavouritesAndSubscriptions(
                                            context,
                                            event,
                                            favouritesIDs,
                                            state);
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 10),
                                          child: state is FavouriteLoading
                                              ? const SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ))
                                              : CustomShowcase(
                                                  favouriteGuide,
                                                  Strings.favouriteGuideMessage,
                                                  (isFavourite
                                                      ? const Icon(
                                                          Icons
                                                              .favorite_rounded,
                                                          color: Colors.white,
                                                          size: 25,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .favorite_outline,
                                                          color: Colors.white,
                                                          size: 25,
                                                        )),
                                                )),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  event.name.toString().toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                      color: AppColors.secondaryColor,
                                      fontFamily: GoogleFonts.sora.toString()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: getDurationDateTime(event),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  MapUtils.openMap(
                                      venue.latitude, venue.longitude, context);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.highlightColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AssetPaths.mapIcon,
                                            color: AppColors.highlightColor,
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Text(
                                              event.loc.toString(),
                                              style: TextStyle(
                                                color: AppColors.highlightColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                          )),
                                          Icon(
                                            Icons.directions,
                                            color: AppColors.highlightColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  Strings.about,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: AppColors.secondaryColor,
                                      fontFamily: GoogleFonts.sora.toString()),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Text(
                                  event.description.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontFamily: GoogleFonts.sora.toString()),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  Strings.organizer,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: AppColors.secondaryColor,
                                      fontFamily: GoogleFonts.sora.toString()),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Text(
                                  event.organizingBody.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontFamily: GoogleFonts.sora.toString()),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  Strings.amount,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: AppColors.secondaryColor,
                                      fontFamily: GoogleFonts.sora.toString()),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Text(
                                  event.total_cost.toString() == "0"
                                      ? Strings.free
                                      : Strings.getAmount(event.total_cost),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontFamily: GoogleFonts.sora.toString()),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.highlightColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      showRegistrationDialog(context);
                                    },
                                    child: Text(
                                      Strings.register,
                                      style: TextStyle(
                                        color: AppColors.secondaryColor,
                                        fontSize: 15,
                                        fontFamily: GoogleFonts.sora.toString(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
              );
            } else if (state is FavouriteFailed) {
              return const Center(
                child: Text(
                  Strings.errorLoading,
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
          }));
}

void updateFavouritesAndSubscriptions(BuildContext context, EventModel event,
    List<String> favouritesIDs, FavouriteState state) async {
  if (state is FavouriteSuccess) {
    var newList = favouritesIDs;
    if (favouritesIDs.contains(event.id)) {
      newList.remove(event.id);
      await FirebaseMessaging.instance
          .unsubscribeFromTopic(event.id.toString());
    } else {
      newList.add(event.id.toString());
      await FirebaseMessaging.instance.subscribeToTopic(event.id.toString());
      showCustomFlushbar(
          Strings.favouriteTitle, Strings.favouriteMessage, context);
    }
    FavouriteModel newFavouriteModel = FavouriteModel(
        uniqueUserId: state.favouriteList.uniqueUserId,
        favouriteEventIds: newList);
    BlocProvider.of<FavouriteCubit>(context)
        .upDateFavourites(newFavouriteModel);
  }
}

displayEventCardShowcase(
    BuildContext context, GlobalKey<State<StatefulWidget>> key1) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? showcaseVisibilityStatus =
      prefs.getBool(SharedPrefKeys.idEventCardShowcase);

  if (showcaseVisibilityStatus == null) {
    prefs.setBool(SharedPrefKeys.idEventCardShowcase, false);
    ShowCaseWidget.of(context).startShowCase([key1]);
  }
}

Text getDurationDateTime(EventModel event) {
  if (parseDate(event.start) == parseDate(event.end)) {
    return Text(
      "${parseDate(event.start)} ${parseTime(event.start)} - ${parseTime(event.end)}",
      style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: Colors.grey,
          fontFamily: GoogleFonts.sora.toString()),
    );
  } else {
    return Text(
      "${parseDate(event.start)} ${parseTime(event.start)} - ${parseDate(event.end)} ${parseTime(event.end)}",
      style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: Colors.grey,
          fontFamily: GoogleFonts.sora.toString()),
    );
  }
}

void showRegistrationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: AlertDialog(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.highlightColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.34,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                    child: Text(
                      Strings.registration,
                      style: GoogleFonts.sora(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                    child: Text(
                      Strings.registrationGuide,
                      style: GoogleFonts.sora(
                          fontWeight: FontWeight.w300, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 8),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.highlightColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          launchURL(Strings.vtopLink, context, true);
                        },
                        child: Text(
                          Strings.vitStudent,
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 15,
                            fontFamily: GoogleFonts.sora.toString(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launchURL(Strings.websiteLink, context, true);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                      child: SizedBox(
                        height: 50,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.highlightColor),
                          ),
                          child: Center(
                            child: Text(
                              Strings.externalParticipant,
                              style: TextStyle(
                                color: AppColors.highlightColor,
                                fontSize: 15,
                                fontFamily: GoogleFonts.sora.toString(),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      child: Text(
                        Strings.externalParticipantGuide,
                        style: GoogleFonts.sora(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
