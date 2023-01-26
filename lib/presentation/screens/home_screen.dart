import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:riviera23/cubit/featured/featured_cubit.dart';
import 'package:riviera23/cubit/proshows/proshows_cubit.dart';
import 'package:riviera23/presentation/screens/announcement_history_screen.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../cubit/events/events_cubit.dart';
import '../../cubit/favourites/favourite_cubit.dart';
import '../../cubit/venue/venue_cubit.dart';
import '../../data/models/venue_model.dart';
import '../../service/auth.dart';
import '../widgets/carousel_with_dots_page.dart';
import '../widgets/featured_events.dart';
import '../widgets/on_going_events.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubitProShows = context.read<ProShowsCubit>();
      cubitProShows.getAllProShows();

      final cubitFeatured = context.read<FeaturedCubit>();
      cubitFeatured.getAllFeatured();

      final user = AuthService(FirebaseAuth.instance).user;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final cubit = context.read<EventsCubit>();
        cubit.getAllEvents();
        final cubit2 = context.read<FavouriteCubit>();
        cubit2.loadFavourites(user);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
            // you can forcefully translate values left side using Transform
            transform: Matrix4.translationValues(10.0, 2.0, 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  'assets/riviera_icon.png',
                  height: 40,
                  width: 90,
                  fit: BoxFit.contain,
                ),
              ),
            )),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AnnouncementHistoryScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: SvgPicture.asset('assets/notification_icon.svg',
                  height: 20, width: 20),
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(child:
              BlocBuilder<VenueCubit, VenueState>(
                  builder: (context, venueState) {
            if (venueState is VenueSuccess) {
              print("Venue Success");
              List<Venue> allVenues = venueState.venuesList;
              return Column(
                children: [
                  CarouselWithDotsPage(
                    allVenues: allVenues,
                  ),
                  SizedBox(height: 30),
                  FeaturedEvents(
                    allVenues: allVenues,
                  ),
                  SizedBox(height: 0),
                  OnGoingEvents(
                    allVenues: allVenues,
                  )
                ],
              );
            } else {
              return Container();
            }
          })),
        ),
      ),
    );
  }

}
