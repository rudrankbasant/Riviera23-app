import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/presentation/methods/parse_datetime.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../cubit/announcements/announcements_cubit.dart';
import '../../data/models/announcement_model.dart';

class AnnouncementHistoryScreen extends StatefulWidget {
  @override
  State<AnnouncementHistoryScreen> createState() =>
      _AnnouncementHistoryScreenState();
}

class _AnnouncementHistoryScreenState extends State<AnnouncementHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
        builder: (context, state) {
          if (state is AnnouncementsSuccess) {
            var groupedList = groupBy(state.announcementsList,
                    (Announcement announcement) => parseDate(announcement.date))
                .entries
                .toList();
            print(groupedList.toString());
            print(groupedList[0].value.toString());
            //sort list
            return Center(
              child: Text("Your Notifications Will Appear here", style: TextStyle(color: Colors.white),),
            )/*ListView.builder(
                itemCount: groupedList.length,
                itemBuilder: (context, position) {
                  var faqQuestion = groupedList[position];
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.primaryColor),
                      child: IntrinsicHeight(
                        child: Row(children: [
                          const VerticalDivider(
                            color: Colors.blue,
                            thickness: 2,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  faqQuestion.key,
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: groupedList[position].value.length,
                                    itemBuilder: (context, itemIndex) {
                                      return Card(
                                        color: AppColors.cardBgColor,
                                        child: Expanded(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            child: Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      groupedList[position]
                                                          .value[itemIndex]
                                                          .heading
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: GoogleFonts
                                                              .sora
                                                              .toString())),
                                                  Text(
                                                      parseDate(
                                                          groupedList[position]
                                                              .value[itemIndex]
                                                              .desc
                                                              .toString()),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          )
                        ]),
                      ),
                    ),
                  );
                })*/;
          }

          return Center(
              child: Text("Loading Announcement History ...",
                  style: TextStyle(color: AppColors.secondaryColor)));
        },
      ),
    );
  }
}
