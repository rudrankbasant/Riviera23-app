import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../cubit/events/events_cubit.dart';
import '../../utils/app_colors.dart';
import 'all_events_screen.dart';
import 'favourite_events_screen.dart';

class EventsScreen extends StatefulWidget {
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<EventsCubit>();
      cubit.getAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.primaryColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Colors.transparent,
              // Status bar brightness (optional)
              statusBarIconBrightness: Brightness.dark,
              // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
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
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: SvgPicture.asset('assets/search_icon.svg',
                    height: 20, width: 20),
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
          ),
          body: TabBarView(
            children: [
              /*BlocBuilder<EventsCubit, EventsState>( builder: (context, state) {
                if (state is EventsSuccess) {
                  return ListView.builder(
                    itemCount: state.events.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Text(state.events[index].name.toString()),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is EventsError) {
                  return Center(
                    child: Text("errorrrr"),
                  );
                } else {
                  debugPrint(state.toString() + "hellllloo");
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })*/
              AllEvents(),
              FavouriteEvents()
            ],
          ),
        )); /* BlocBuilder<EventsCubit, EventsState>( builder: (context, state) {
      if (state is EventsSuccess) {
        return ListView.builder(
          itemCount: state.events.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: [
                  Text(state.events[index].name.toString()),
                ],
              ),
            );
          },
        );
      } else if (state is EventsError) {
        return Center(
          child: Text("errorrrr"),
        );
      } else {
        debugPrint(state.toString() + "hellllloo");
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });*/
  }
}
