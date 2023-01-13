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
import '../../service/auth.dart';
import '../widgets/carousel_with_dots_page.dart';
import '../widgets/featured_events.dart';
import '../widgets/on_going_events.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcXEqlEubvX7ovdwnaxhky3TMmJETxGRQ6hymMjC0hr6iClwzAL0t6Vf2KWp-IFjVPXrE&usqp=CAU',
    'https://yt3.ggpht.com/kfw_1eOpjdYASmlAnSPa7XmXrYpaKjuW4k7_oB-hD5ljRSlT7yThew72ZxgW1UrAJ1e8vX1G=s900-c-k-c0x00ffffff-no-rj',
    'https://res.cloudinary.com/dwzmsvp7f/image/fetch/q_75,f_auto,w_800/https%3A%2F%2Fmedia.insider.in%2Fimage%2Fupload%2Fc_crop%2Cg_custom%2Fv1657448440%2Fkqvmc4uvv9ye2c4zppin.jpg',
  ];

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                CarouselWithDotsPage(imgList: imgList),
                SizedBox(height: 30),
                FeaturedEvents(imgList: imgList),
                SizedBox(height: 0),
                OnGoingEvents()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
