import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/data/models/favourite_model.dart';
import 'package:riviera23/presentation/methods/parse_datetime.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../cubit/favourites/favourite_cubit.dart';
import '../../data/models/event_model.dart';

void showCustomBottomSheet(BuildContext context, EventModel event) {
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
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
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
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Stack(
                            children: [
                              ShaderMask(
                                shaderCallback: (rect) {
                                  return const LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                    colors: [Colors.black, Colors.transparent],
                                  ).createShader(
                                      Rect.fromLTRB(0, 0, rect.width, rect.height));
                                },
                                blendMode: BlendMode.dstOut,
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width,
                                  child: FadeInImage(image: NetworkImage(event.imageUrl.toString()), placeholder: NetworkImage("https://i.ytimg.com/vi/v2gseMj1UGI/maxresdefault.jpg"), fit: BoxFit.cover,),

                                ),
                              ),
                              Positioned(
                                left: 0.0,
                                bottom: 0.0,
                                child: GestureDetector(
                                  onTap: () {
                                    if (state is FavouriteSuccess) {
                                      var newList = favouritesIDs;
                                      favouritesIDs.contains(event.id)
                                          ? newList.remove(event.id)
                                          : newList.add(event.id.toString());
                                      FavouriteModel newFavouriteModel =
                                      FavouriteModel(
                                          uniqueUserId:
                                          state.favouriteList.uniqueUserId,
                                          favouriteEventIds: newList);
                                      BlocProvider.of<FavouriteCubit>(context)
                                          .upDateFavourites(newFavouriteModel);
                                    }
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                      child: state is FavouriteLoading? SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: Colors.white,)) :(isFavourite
                                          ? Icon(
                                        Icons.favorite_rounded,
                                        color: Colors.white,
                                        size: 25,
                                      )
                                          : Icon(
                                        Icons.favorite_outline,
                                        color: Colors.white,
                                        size: 25,
                                      ))
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "EVENT ON ${parseDate(event.start)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                  color: AppColors.secondaryColor,
                                  fontFamily: GoogleFonts.sora.toString()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "${parseTime(event.start)} at ${event.loc}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  color: AppColors.secondaryColor,
                                  fontFamily: GoogleFonts.sora.toString()),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text(
                              "ABOUT",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: AppColors.secondaryColor,
                                  fontFamily: GoogleFonts.sora.toString()),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              event.description.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: AppColors.secondaryColor,
                                  fontFamily: GoogleFonts.sora.toString()),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text(
                              "INSTRUCTIONS",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: AppColors.secondaryColor,
                                  fontFamily: GoogleFonts.sora.toString()),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Text(
                              event.instructions.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: AppColors.secondaryColor,
                                  fontFamily: GoogleFonts.sora.toString()),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

              );
            } else if (state is FavouriteFailed) {
              return Center(
                child: Text(
                  "Error Loading",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }));
}
