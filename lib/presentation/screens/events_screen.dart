import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:riviera23/cubit/favourites/favourite_cubit.dart';
import 'package:riviera23/data/models/event_model.dart';
import 'package:riviera23/presentation/methods/show_event_details.dart';
import 'package:riviera23/utils/app_theme.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedPlace = 0;
  int selectedDay = 0;

  int placeSelection = 0;
  int daySelection = 0;
  bool defaultAppBar = true;
  String eventsSearchQuery = "";
  final user = AuthService(FirebaseAuth.instance).user;
  var isFavourite = false;

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer(bool applyFilter) {
    if (applyFilter) {
      setState(() {
        placeSelection = selectedPlace;
        daySelection = selectedDay;
      });
    } else {
      placeSelection = 0;
      daySelection = 0;
    }

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    selectedPlace = 0;
    selectedDay = 0;
    placeSelection = 0;
    daySelection = 0;
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
          key: _scaffoldKey,
          backgroundColor: AppColors.primaryColor,
          resizeToAvoidBottomInset: false,
          appBar: defaultAppBar
              ? AppBar(
                  automaticallyImplyLeading: false,
                  /*systemOverlayStyle: const SystemUiOverlayStyle(
                    // Status bar color
                    statusBarColor: Colors.transparent,
                    // Status bar brightness (optional)
                    statusBarIconBrightness: Brightness.dark,
                    // For Android (dark icons)
                    statusBarBrightness:
                        Brightness.light, // For iOS (dark icons)
                  )*/
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
                      child: GestureDetector(
                        onTap: () {
                          _openEndDrawer();
                        },
                        child: SvgPicture.asset('assets/filter_icon.svg',
                            height: 20, width: 20),
                      ),
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
                  automaticallyImplyLeading: false,
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
          endDrawer: Drawer(
              backgroundColor: AppColors.primaryColor,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              _closeEndDrawer(false);
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                        Text(
                          "Event Filter",
                          style: AppTheme.appTheme.textTheme.headline6,
                        ),
                        GestureDetector(
                            onTap: () {
                              _closeEndDrawer(true);
                            },
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 0, 10),
                    child: SizedBox(
                        child: Text("Event Day",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ))),
                  ),
                  SizedBox(
                    height: 60,
                    child: ListView(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildDaysRadioListTile(0, "All"),
                        buildDaysRadioListTile(1, "23 Feb 2023"),
                        buildDaysRadioListTile(2, "24 Feb 2023"),
                        buildDaysRadioListTile(3, "25 Feb 2023"),
                        buildDaysRadioListTile(4, "26 Feb 2023"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 0, 10),
                    child: SizedBox(
                        child: Text("Places",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ))),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.white,
                        disabledColor: Colors.blue),
                    child: Column(
                      children: [
                        buildPlacesRadioListTile(0, "All"),
                        buildPlacesRadioListTile(1, "Outdoor Stadium"),
                        buildPlacesRadioListTile(2, "Kalpana Chawla Ground"),
                        buildPlacesRadioListTile(3, "SJT"),
                        buildPlacesRadioListTile(4, "Main Building"),
                        buildPlacesRadioListTile(5, "Woodys"),
                        buildPlacesRadioListTile(6, "Foodys"),
                        buildPlacesRadioListTile(7, "Greenos"),
                        buildPlacesRadioListTile(8, "Technology Tower (TT)"),
                        buildPlacesRadioListTile(9, "MGB"),
                      ],
                    ),
                  ),
                ],
              )),
          body: TabBarView(
            children: [
              BlocBuilder<EventsCubit, EventsState>(builder: (context, state) {
                if (state is EventsSuccess) {
                  List<EventModel> filteredEvents =
                      runFilter(state.events, placeSelection, daySelection);
                  List<EventModel> searchedEvents =
                      runSearch(filteredEvents, eventsSearchQuery);
                  return ListView.builder(
                    itemCount: searchedEvents.length,
                    itemBuilder: (context, index) {
                      EventModel event = searchedEvents[index];
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
                      List<EventModel> filteredFavEvents = runFilter(
                          favouriteEvents, placeSelection, daySelection);
                      List<EventModel> searchedFavEvents =
                          runSearch(filteredFavEvents, eventsSearchQuery);
                      return ListView.builder(
                        itemCount: searchedFavEvents.length,
                        itemBuilder: (context, index) {
                          EventModel event = searchedFavEvents[index];
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
                  child: FadeInImage(
                    image: NetworkImage(event.imageUrl.toString()),
                    placeholder: NetworkImage(event.imageUrl.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
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
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<EventModel> runSearch(List<EventModel> events, String? query) {
    List<EventModel> searchedEvents = [];
    if (query != null) {
      for (EventModel event in events) {
        if (event.name!.toLowerCase().contains(query.toLowerCase())) {
          searchedEvents.add(event);
        }
      }
    } else {
      searchedEvents = events;
    }
    return searchedEvents;
  }

  List<EventModel> runFilter(List<EventModel> events, int place, int day) {
    List<String> places = [
      "All",
      "Outdoor Stadium",
      "Kalpana Chawla Ground",
      "SJT",
      "Main Building",
      "Woodys",
      "Foodys",
      "Greenos",
      "Technology Tower (TT)",
      "MGB"
    ];

    List<EventModel> filteredEvents = events;

    if (place != 0 && day == 0) {
      filteredEvents = [];
      for (EventModel event in events) {
        if (event.loc == places[place]) {
          filteredEvents.add(event);
        }
      }
    }
    if (place == 0 && day != 0) {
      filteredEvents = [];
      for (EventModel event in events) {
        if (getDayofWeek(event.start) == getEventDay(day)) {
          filteredEvents.add(event);
        }
      }
    }
    if (place != 0 && day != 0) {
      filteredEvents = [];
      for (EventModel event in events) {
        if (getDayofWeek(event.start) == getEventDay(day) &&
            event.loc == places[place]) {
          filteredEvents.add(event);
        }
      }
    }

    return filteredEvents;
  }

  getEventDay(int day) {
    switch (day) {
      case 1:
        return "thursday";
      case 2:
        return "friday";
      case 3:
        return "saturday";
      case 4:
        return "sunday";
      default:
        return "none";
    }
  }

  String getDayofWeek(String? datetime) {
    if (datetime != null) {
      DateTime date = DateTime.parse(datetime);
      return DateFormat('EEEE').format(date).toLowerCase();
    }
    return "none";
  }

  RadioListTile<int> buildPlacesRadioListTile(int index, String place) {
    return RadioListTile(
        value: index,
        groupValue: selectedPlace,
        onChanged: (value) {
          setState(() {
            selectedPlace = value as int;
          });
        },
        title: Text(place));
  }

  Padding buildDaysRadioListTile(int index, String day) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDay = index;
          });
        },
        child: Container(
          height: 40,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: (index == selectedDay) ? Colors.blue : Colors.white),
          ),
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: (index == selectedDay) ? Colors.blue : Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
