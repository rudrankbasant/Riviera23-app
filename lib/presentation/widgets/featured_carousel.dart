import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/data/models/venue_model.dart';
import 'package:riviera23/presentation/methods/get_venue.dart';
import 'package:riviera23/presentation/methods/parse_datetime.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../cubit/events/events_cubit.dart';
import '../../cubit/events/events_state.dart';
import '../../data/models/event_model.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants/strings/asset_paths.dart';
import '../../utils/constants/strings/strings.dart';
import '../methods/show_event_details.dart';

class FeaturedEvents extends StatefulWidget {
  final List<Venue> allVenues;

  const FeaturedEvents({super.key, required this.allVenues});

  @override
  State<FeaturedEvents> createState() {
    return _FeaturedEventsState();
  }
}

class _FeaturedEventsState extends State<FeaturedEvents> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(builder: (context, state) {
      if (state is EventsSuccess) {
        List<EventModel> featuredEvents =
            state.events.where((element) => element.featured == true).toList();
        final List<Widget> imageSliders = featuredEvents
            .map((item) => GestureDetector(
                  onTap: () {
                    showCustomBottomSheet(
                        context, item, getVenue(widget.allVenues, item));
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
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            child: CachedNetworkImage(
                              height: 250,
                              width: 200,
                              imageUrl: item.imageUrl.toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 250.0,
                                width: 200.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: AppColors.primaryColor,
                                highlightColor: Colors.grey,
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Image.asset(AssetPaths.placeholder),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            item.name.toString(),
                            style: GoogleFonts.sora(
                                color: AppColors.highlightColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 16),
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Strings.featuredEventsTitle,
                      style: AppTheme.appTheme.textTheme.titleLarge),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/events', arguments: 0);
                      },
                      child: Text(Strings.seeMore,
                          style: TextStyle(color: AppColors.highlightColor)))
                ],
              ),
            ),
            featuredEvents.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 100, 0, 100),
                      child: Text(
                        Strings.featuredEventsEmpty,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  )
                : CarouselSlider(
                    items: imageSliders,
                    options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 6),
                        enlargeCenterPage: false,
                        aspectRatio: 1 / 0.95,
                        viewportFraction: 0.5,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
          ],
        );
      } else if (state is EventsError) {
        return const Center(
          child: Text(
            Strings.errorLoading,
            style: TextStyle(color: Colors.white),
          ),
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
