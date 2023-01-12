import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/presentation/methods/parse_datetime.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../cubit/events/events_cubit.dart';
import '../../cubit/events/events_state.dart';
import '../../data/models/event_model.dart';
import '../../utils/app_theme.dart';
import '../methods/show_event_details.dart';

class OnGoingEvents extends StatefulWidget {
  @override
  _OnGoingEventsState createState() => _OnGoingEventsState();
}

class _OnGoingEventsState extends State<OnGoingEvents> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(builder: (context, state) {
      if (state is EventsSuccess) {
        List<EventModel> onGoingEvents =
            state.events.where((element) => isGoingOn(element)).toList();
        print("ongoing-- ${onGoingEvents.length}");
        final List<Widget> imageSliders = onGoingEvents
            .map((item) => GestureDetector(
                  onTap: () {
                    showCustomBottomSheet(context, item);
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
                              placeholder: const NetworkImage(
                                  "https://i.ytimg.com/vi/v2gseMj1UGI/maxresdefault.jpg"),
                              fit: BoxFit.cover,
                            ),
                            /* child: Image.network(
                              item.imageUrl.toString(),
                              fit: BoxFit.cover,
                            )*/
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
                  Text("ONGOING EVENTS",
                      style: AppTheme.appTheme.textTheme.headline6),
                ],
              ),
            ),
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: false,
                  aspectRatio: 1 / 1,
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
          child: Text("Error! Couldn't load."),
        );
      } else {
        return Container();
      }
    });
  }

  bool isGoingOn(EventModel element) {
    var currentDateTime = DateTime.now();
    if (element.start != null && element.end != null) {
      var startDateTime = DateTime.parse(element.start.toString());
      var endDateTime = DateTime.parse(element.end.toString());
      if (currentDateTime.isAfter(startDateTime) &&
          currentDateTime.isBefore(endDateTime)) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }
}