import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riviera23/presentation/methods/show_event_details.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/strings/asset_paths.dart';
import '../../constants/strings/strings.dart';
import '../../cubit/events/events_cubit.dart';
import '../../cubit/events/events_state.dart';
import '../../data/models/event_model.dart';
import '../../data/models/venue_model.dart';
import '../../utils/app_theme.dart';
import '../methods/get_venue.dart';
import '../screens/merch_screen.dart';

class CarouselWithDotsPage extends StatefulWidget {
  List<Venue> allVenues;

  CarouselWithDotsPage({super.key, required this.allVenues});

  @override
  _CarouselWithDotsPageState createState() => _CarouselWithDotsPageState();
}

class _CarouselWithDotsPageState extends State<CarouselWithDotsPage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<EventsCubit, EventsState>(builder: (context, state) {
      if (state is EventsSuccess) {
        List<EventModel> proshows = state.events
            .where((element) => element.eventType?.toLowerCase() == "proshow")
            .toList();
        if (proshows.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                  child: Text(Strings.proshows,
                      style: AppTheme.appTheme.textTheme.titleLarge),
                ),
                Opacity(
                    opacity: 0.8, child: Image.asset(AssetPaths.prowShowBg)),
              ],
            ),
          );
        }
        if (proshows.length > 20) {
          final nProShows = proshows.getRange(0, 20);
          proshows = nProShows.toList();
        }
        final List<Widget> imageSliders = proshows
            .map((item) => GestureDetector(
                  onTap: () {
                    showCustomBottomSheet(
                        context, item, getVenue(widget.allVenues, item));
                  },
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: item.imageUrl.toString(),
                        imageBuilder: (context, imageProvider) => Center(
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Text(
                            '${item.name}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Axis',
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
            .toList();

        return Column(
          children: [
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  enlargeCenterPage: false,
                  aspectRatio: 16 / 12,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: proshows.map((proshow) {
                int index = proshows.indexOf(proshow);
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 3,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? AppColors.highlightColor
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MerchScreen()));
              },
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Image.asset(
                      AssetPaths.merchBanner,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
            ),
          ],
        );
      } else if (state is EventsError) {
        return const Center(
          child:
              Text(Strings.errorLoading, style: TextStyle(color: Colors.white)),
        );
      } else {
        return Center(
          child: Column(
            children: [
              const SizedBox(
                height: 200,
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
