import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/data/models/venue_model.dart';
import 'package:riviera23/presentation/methods/get_venue.dart';
import 'package:riviera23/presentation/methods/parse_datetime.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../cubit/featured/featured_cubit.dart';
import '../../cubit/featured/featured_state.dart';
import '../../utils/app_theme.dart';
import '../methods/show_event_details.dart';
import '../screens/events_screen.dart';

class FeaturedEvents extends StatefulWidget {
  List<Venue> allVenues;

  FeaturedEvents({required this.allVenues});

  @override
  _FeaturedEventsState createState() => _FeaturedEventsState();
}

class _FeaturedEventsState extends State<FeaturedEvents> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturedCubit, FeaturedState>(builder: (context, state) {
      if (state is FeaturedSuccess) {
        final List<Widget> imageSliders = state.featured
            .map((item) => GestureDetector(
                  onTap: () {
                    showCustomBottomSheet(context, item, getVenue(widget.allVenues, item));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: AppColors.primaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 250,
                            width: 200,
                            child: FadeInImage(
                              image: NetworkImage(item.imageUrl.toString()),
                              placeholder: const AssetImage("assets/app_icon.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            item.name.toString(),
                            style: TextStyle(
                                fontFamily: GoogleFonts.sora.toString(),
                                color: AppColors.highlightColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            parseDate(item.start),
                            style: TextStyle(
                                fontFamily: GoogleFonts.sora.toString(),
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            item.loc.toString(),
                            style: TextStyle(
                                fontFamily: GoogleFonts.sora.toString(),
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
            .toList();

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("FEATURED EVENTS",
                      style: AppTheme.appTheme.textTheme.headline6),
                  GestureDetector(
                    onTap:(){ Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EventsScreen(0)));},
                      child: Text("See more", style: TextStyle(color: AppColors.highlightColor)))
                ],
              ),
            ),
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  enlargeCenterPage: false,
                  aspectRatio: 1/1,
                  viewportFraction: 0.5,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ],
        );
      } else if (state is FeaturedError) {
        return const Center(
          child: Text("Error! Couldn't load.", style: TextStyle(color: Colors.white),),
        );
      } else {
        return Center(
          child: Column(
            children: [
              const SizedBox(
                height: 300,
              ),
              SpinKitThreeBounce(
                color: AppColors.secondaryColor,
                size: 30,
              ),
            ],
          ),
        );
      }
    });
  }
}
