import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/cubit/auth/auth_cubit.dart';
import 'package:riviera23/cubit/favourites/favourite_cubit.dart';
import 'package:riviera23/cubit/venue/venue_cubit.dart';
import 'package:riviera23/data/models/event_model.dart';
import 'package:riviera23/presentation/methods/show_event_details.dart';
import 'package:riviera23/utils/app_theme.dart';
import 'package:shimmer/shimmer.dart';
import '../../cubit/events/events_cubit.dart';
import '../../cubit/events/events_state.dart';
import '../../data/models/venue_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants/strings/asset_paths.dart';
import '../../utils/constants/strings/strings.dart';
import '../methods/get_venue.dart';
import '../methods/parse_datetime.dart';

class EventsScreen extends StatefulWidget {
  final int? index;

  const EventsScreen(this.index, {super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> selectedPlaces = [];
  List<String> selectedDays = [];

  List<String> placeSelections = [];
  List<String> daySelections = [];

  bool defaultAppBar = true;
  String eventsSearchQuery = "";

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer(bool applyFilter) {
    if (applyFilter) {
      setState(() {
        placeSelections = selectedPlaces;
        daySelections = selectedDays;
      });
    } else {
      placeSelections = [];
      daySelections = [];
      selectedPlaces = [];
      selectedDays = [];
    }

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    selectedPlaces = [];
    selectedDays = [];
    placeSelections = [];
    daySelections = [];
    defaultAppBar = true;
    eventsSearchQuery = "";

    final user = AuthCubit().user;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<EventsCubit>();
      cubit.getAllEvents();
      final cubit3 = context.read<FavouriteCubit>();
      cubit3.loadFavourites(user);
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
          appBar: defaultAppBar ? buildAppBar() : buildSearchBar(),
          endDrawer: buildDrawer(context),
          body: TabBarView(
            children: [buildAllEvents(), buildFavouriteEvents()],
          ),
        ));
  }

  BlocBuilder<EventsCubit, EventsState> buildFavouriteEvents() {
    return BlocBuilder<EventsCubit, EventsState>(builder: (context, state) {
      if (state is EventsSuccess) {
        List<EventModel> allEvents = state.events;
        return BlocBuilder<FavouriteCubit, FavouriteState>(
            builder: (context, state) {
          if (state is FavouriteSuccess) {
            List<String> favouritesIDs = state.favouriteList.favouriteEventIds;
            List<EventModel> favouriteEvents =
                getFavouriteEvents(favouritesIDs, allEvents);

            if (favouriteEvents.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Text(
                    Strings.subsGuideEvents,
                    style: GoogleFonts.sora(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return BlocBuilder<VenueCubit, VenueState>(
                builder: (context, venueState) {
              if (venueState is VenueSuccess) {
                List<Venue> allVenues = venueState.venuesList;
                List<EventModel> filteredFavEvents = runFilter(
                    favouriteEvents, allVenues, placeSelections, daySelections);
                List<EventModel> searchedFavEvents =
                    runSearch(filteredFavEvents, eventsSearchQuery);
                sortEvents(searchedFavEvents);
                putPastEventsAtBottom(searchedFavEvents);
                if (searchedFavEvents.isEmpty) {
                  return const Center(
                    child: Text(
                      Strings.noEvents,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: searchedFavEvents.length,
                  itemBuilder: (context, index) {
                    EventModel event = searchedFavEvents[index];
                    return buildEventCard(context, event, allVenues);
                  },
                );
              } else {
                return Container();
              }
            });
          } else if (state is FavouriteFailed) {
            return const Center(
              child: Text(
                Strings.placeholderTextEvents,
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
        });
      } else if (state is EventsError) {
        return const Center(
          child: Text(Strings.errorLoading),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }
    });
  }

  BlocBuilder<EventsCubit, EventsState> buildAllEvents() {
    return BlocBuilder<EventsCubit, EventsState>(builder: (context, state) {
      if (state is EventsSuccess) {
        return BlocBuilder<VenueCubit, VenueState>(
            builder: (context, venueState) {
          if (venueState is VenueSuccess) {
            List<Venue> allVenues = venueState.venuesList;
            List<EventModel> filteredEvents = runFilter(
                state.events, allVenues, placeSelections, daySelections);
            List<EventModel> searchedEvents =
                runSearch(filteredEvents, eventsSearchQuery);
            sortEvents(searchedEvents);
            putPastEventsAtBottom(searchedEvents);
            if (searchedEvents.isEmpty) {
              return const Center(
                child: Text(
                  Strings.noEvents,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              itemCount: searchedEvents.length,
              itemBuilder: (context, index) {
                EventModel event = searchedEvents[index];
                return buildEventCard(context, event, allVenues);
              },
            );
          } else {
            return Container();
          }
        });
      } else if (state is EventsError) {
        return const Center(
          child: Text(Strings.errorLoading),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    });
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
        backgroundColor: AppColors.primaryColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 12.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        _closeEndDrawer(false);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                  Text(
                    Strings.eventFilter,
                    style: AppTheme.appTheme.textTheme.titleLarge,
                  ),
                  GestureDetector(
                      onTap: () {
                        _closeEndDrawer(true);
                      },
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildDateFilterHeading(),
                    buildDateFilter(),
                    const SizedBox(
                      height: 20,
                    ),
                    buildVenueFilterHeading(),
                    buildVenueFilter(context),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Theme buildVenueFilter(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.white, disabledColor: Colors.blue),
      child:
          BlocBuilder<VenueCubit, VenueState>(builder: (context, venueState) {
        if (venueState is VenueSuccess) {
          List<Venue> allVenues = venueState.venuesList;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            itemCount: allVenues.length,
            itemBuilder: (context, index) {
              return buildPlacesCheckBoxListTile(
                  index, allVenues[index].venue_name);
            },
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: SpinKitThreeBounce(
                color: AppColors.secondaryColor,
                size: 30,
              ),
            ),
          );
        }
      }),
    );
  }

  Padding buildVenueFilterHeading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 15, 10),
      child: SizedBox(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(Strings.venues,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
          Visibility(
            visible: selectedPlaces.isNotEmpty,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedPlaces = [];
                });
              },
              child: const Text(Strings.clearAll,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
        ],
      )),
    );
  }

  SizedBox buildDateFilter() {
    return SizedBox(
      height: 60,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          buildDaysRadioListTile(0, Strings.day1),
          buildDaysRadioListTile(1, Strings.day2),
          buildDaysRadioListTile(2, Strings.day3),
          buildDaysRadioListTile(3, Strings.day4),
        ],
      ),
    );
  }

  Padding buildDateFilterHeading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 12.5, 15, 10),
      child: SizedBox(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(Strings.eventDates,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
          Visibility(
            visible: selectedDays.isNotEmpty,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedDays = [];
                });
              },
              child: const Text(Strings.clearAll,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
        ],
      )),
    );
  }

  AppBar buildSearchBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0.0,
      leading: const Icon(Icons.search),
      title: TextField(
        onChanged: (value) {
          setState(() {
            eventsSearchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: Strings.search,
          hintStyle: TextStyle(color: AppColors.secondaryColor),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                defaultAppBar = true;
                eventsSearchQuery = "";
              });
            },
            icon: const Icon(Icons.close))
      ],
      bottom: const TabBar(
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            text: Strings.allEvents,
          ),
          Tab(
            text: Strings.favouriteEvents,
          )
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0.0,
      title: Transform(
          // you can forcefully translate values left side using Transform
          transform: Matrix4.translationValues(10.0, 2.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset(
              AssetPaths.rivieraIcon,
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
            child:
                SvgPicture.asset(AssetPaths.searchIcon, height: 20, width: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: GestureDetector(
            onTap: () {
              _openEndDrawer();
            },
            child:
                SvgPicture.asset(AssetPaths.filterIcon, height: 20, width: 20),
          ),
        ),
      ],
      bottom: const TabBar(
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            text: Strings.allEvents,
          ),
          Tab(
            text: Strings.favouriteEvents,
          )
        ],
      ),
    );
  }

  GestureDetector buildEventCard(
      BuildContext context, EventModel event, List<Venue> allVenues) {
    return GestureDetector(
      onTap: () {
        showCustomBottomSheet(context, event, getVenue(allVenues, event));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Card(
          color: AppColors.cardBgColor,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.height * 0.15,
                  child: CachedNetworkImage(
                    height: 250,
                    width: 200,
                    imageUrl: event.imageUrl.toString(),
                    imageBuilder: (context, imageProvider) => Container(
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
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(event.name.toString(),
                          style: GoogleFonts.sora(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20)),
                      getDurationDate(event),
                      Text(
                          "${event.loc.toString()} |  ${event.total_cost.toString() == "0" ? Strings.free : Strings.getAmount(event.total_cost)}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13.0,
                            fontWeight: FontWeight.normal,
                          )),
                      const SizedBox(height: 10),
                      Expanded(
                          child: Text(event.description.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                                overflow: TextOverflow.fade,
                              ),
                              softWrap: true)),
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

  Text getDurationDate(EventModel event) {
    if (parseDate(event.start) == parseDate(event.end)) {
      return Text(parseDate(event.start),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13.0,
            fontWeight: FontWeight.normal,
          ));
    } else {
      return Text("${parseDate(event.start)} - ${parseDate(event.end)}",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13.0,
            fontWeight: FontWeight.normal,
          ));
    }
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

  List<EventModel> runFilter(List<EventModel> events, List<Venue> allVenues,
      List<String> places, List<String> dates) {
    List<EventModel> filteredEvents = events;

    if (places.isNotEmpty && dates.isEmpty) {
      filteredEvents = [];
      for (EventModel event in events) {
        if (places.contains(getVenue(allVenues, event).venue_name)) {
          filteredEvents.add(event);
        }
      }
    }
    if (places.isEmpty && dates.isNotEmpty) {
      filteredEvents = [];
      for (EventModel event in events) {
        if (dates.contains(parseDate(event.start))) {
          filteredEvents.add(event);
        }
      }
    }
    if (places.isNotEmpty && dates.isNotEmpty) {
      filteredEvents = [];
      for (EventModel event in events) {
        if (dates.contains(parseDate(event.start)) &&
            places.contains(getVenue(allVenues, event).venue_name)) {
          filteredEvents.add(event);
        }
      }
    }

    return filteredEvents;
  }

  Padding buildDaysRadioListTile(int index, String day) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (selectedDays.contains(day)) {
              selectedDays.remove(day);
            } else {
              selectedDays.add(day);
            }
          });
        },
        child: Container(
          height: 40,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: (selectedDays.contains(day))
                    ? AppColors.highlightColor
                    : Colors.white),
          ),
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: (selectedDays.contains(day))
                    ? AppColors.highlightColor
                    : Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  CheckboxListTile buildPlacesCheckBoxListTile(int index, String place) {
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: AppColors.highlightColor,
        activeColor: AppColors.primaryColor,
        selectedTileColor: AppColors.secondaryColor,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        value: selectedPlaces.contains(place),
        onChanged: (value) {
          setState(() {
            if (selectedPlaces.contains(place)) {
              selectedPlaces.remove(place);
            } else {
              selectedPlaces.add(place);
            }
          });
        },
        title: Text(place));
  }

  void putPastEventsAtBottom(List<EventModel> searchedEvents) {
    List<EventModel> pastEvents = [];
    List<EventModel> upcomingEvents = [];
    for (EventModel event in searchedEvents) {
      //compare iso date with null safety
      if (event.end != null) {
        if (DateTime.parse(event.end!).isBefore(DateTime.now())) {
          pastEvents.add(event);
        } else {
          upcomingEvents.add(event);
        }
      } else {
        pastEvents.add(event);
      }
    }
    searchedEvents.clear();
    searchedEvents.addAll(upcomingEvents);
    searchedEvents.addAll(pastEvents);
  }

  void sortEvents(List<EventModel> searchedEvents) {
    searchedEvents.sort((a, b) {
      if (a.start == null && b.start == null) {
        return 0;
      } else if (a.start == null) {
        return 1;
      } else if (b.start == null) {
        return -1;
      } else {
        return a.start!.compareTo(b.start!);
      }
    });
  }

  List<EventModel> getFavouriteEvents(
      List<String> favouritesIDs, List<EventModel> allEvents) {
    List<EventModel> favouriteEvents = [];
    for (int i = 0; i < favouritesIDs.length; i++) {
      for (int j = 0; j < allEvents.length; j++) {
        if (favouritesIDs[i] == allEvents[j].id) {
          favouriteEvents.add(allEvents[j]);
        }
      }
    }
    return favouriteEvents;
  }
}
