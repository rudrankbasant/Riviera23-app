import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/cubit/favourites/favourite_cubit.dart';
import 'package:riviera23/data/models/event_model.dart';
import 'package:riviera23/data/models/favourite_model.dart';
import 'package:riviera23/presentation/methods/show_event_details.dart';

import '../../cubit/events/events_cubit.dart';
import '../../cubit/events/events_state.dart';
import '../../service/auth.dart';
import '../../utils/app_colors.dart';
import '../methods/parse_datetime.dart';

class EventsScreen extends StatefulWidget {
  int? index;

  EventsScreen(this.index);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool defaultAppBar = true;
  String eventsSearchQuery = "";
  final user = AuthService(FirebaseAuth.instance).user;
  var isFavourite = false;

  @override
  void initState() {
    super.initState();
    defaultAppBar = true;
    eventsSearchQuery = "";
    final user = AuthService(FirebaseAuth.instance).user;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<EventsCubit>();
      cubit.getAllEvents();
      final cubit2 = context.read<FavouriteCubit>();
      cubit2.loadFavourites(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: widget.index ?? 0,
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.primaryColor,
          resizeToAvoidBottomInset: false,
          appBar: defaultAppBar
              ? AppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    // Status bar color
                    statusBarColor: Colors.transparent,
                    // Status bar brightness (optional)
                    statusBarIconBrightness: Brightness.dark,
                    // For Android (dark icons)
                    statusBarBrightness:
                        Brightness.light, // For iOS (dark icons)
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: false,
                  titleSpacing: 0.0,
                  title: Transform(
                      // you can forcefully translate values left side using Transform
                      transform: Matrix4.translationValues(10.0, 2.0, 0.0),
                      child: Container(
                        child: Image.asset(
                          'assets/riviera_icon.png',
                          height: 40,
                          width: 90,
                          fit: BoxFit.contain,
                        ),
                      )),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          defaultAppBar = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: SvgPicture.asset('assets/search_icon.svg',
                            height: 20, width: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: SvgPicture.asset('assets/filter_icon.svg',
                          height: 20, width: 20),
                    ),
                  ],
                  bottom: const TabBar(
                    tabs: [
                      Tab(
                        text: "All Events",
                      ),
                      Tab(
                        text: "Favourites",
                      )
                    ],
                  ),
                )
              : AppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    // Status bar color
                    statusBarColor: Colors.transparent,
                    // Status bar brightness (optional)
                    statusBarIconBrightness: Brightness.dark,
                    // For Android (dark icons)
                    statusBarBrightness:
                        Brightness.light, // For iOS (dark icons)
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  titleSpacing: 0.0,
                  leading: Icon(Icons.search),
                  title: TextField(
                    onChanged: (value) {
                      setState(() {
                        eventsSearchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: AppColors.secondaryColor)),
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            defaultAppBar = true;
                            eventsSearchQuery = "";
                          });
                        },
                        icon: Icon(Icons.close))
                  ],
                  bottom: const TabBar(
                    tabs: [
                      Tab(
                        text: "All Events",
                      ),
                      Tab(
                        text: "Favourites",
                      )
                    ],
                  ),
                ),
          body: TabBarView(
            children: [
              BlocBuilder<EventsCubit, EventsState>(builder: (context, state) {
                if (state is EventsSuccess) {
                  List<EventModel> filteredEvents =
                      runFilter(state.events, eventsSearchQuery);
                  return ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      EventModel event = filteredEvents[index];
                      return buildEventCard(context, event);
                    },
                  );
                } else if (state is EventsError) {
                  return const Center(
                    child: Text("Error! Couldn't load."),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
              BlocBuilder<EventsCubit, EventsState>(builder: (context, state) {
                if (state is EventsSuccess) {
                  List<EventModel> allEvents = state.events;
                  return BlocBuilder<FavouriteCubit, FavouriteState>(
                      builder: (context, state) {
                    if (state is FavouriteSuccess) {
                      List<String> favouritesIDs =
                          state.favouriteList.favouriteEventIds;
                      List<EventModel> favouriteEvents = [];
                      for (int i = 0; i < favouritesIDs.length; i++) {
                        for (int j = 0; j < allEvents.length; j++) {
                          if (favouritesIDs[i] == allEvents[j].id) {
                            favouriteEvents.add(allEvents[j]);
                          }
                        }
                      }
                      List<EventModel> filteredFavEvents =
                          runFilter(favouriteEvents, eventsSearchQuery);
                      return ListView.builder(
                        itemCount: filteredFavEvents.length,
                        itemBuilder: (context, index) {
                          EventModel event = filteredFavEvents[index];
                          return buildEventCard(context, event);
                        },
                      );
                    } else if (state is FavouriteFailed) {
                      return const Center(
                        child: Text(
                          "Add some favourites by liking an event!",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
                } else if (state is EventsError) {
                  return const Center(
                    child: Text("Error! Couldn't load."),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
            ],
          ),
        ));
  }

  GestureDetector buildEventCard(BuildContext context, EventModel event) {
    return GestureDetector(
      onTap: () {
        showCustomBottomSheet(context, event);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Card(
          color: AppColors.cardBgColor,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.15,
                    child: Image.network(
                      event.imageUrl.toString(),
                      fit: BoxFit.cover,
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(event.name.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.sora.toString())),
                  Text(parseDate(event.start),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      )),
                  Text(event.loc.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      )),
                  SizedBox(height: 10),
                  Text(
                    event.description.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<EventModel> runFilter(List<EventModel> events, String? query) {
    List<EventModel> filteredEvents = [];
    if (query != null) {
      for (EventModel event in events) {
        if (event.name!.toLowerCase().contains(query.toLowerCase())) {
          filteredEvents.add(event);
        }
      }
    } else {
      filteredEvents = events;
    }
    return filteredEvents;
  }

  FavouriteModel getSample() {
    List<String> favs = [];

    favs.add("kendrick");
    favs.add("lamar");
    favs.add("best");

    return FavouriteModel(
        uniqueUserId: user.uid.toString(), favouriteEventIds: favs);
  }
}
