import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/presentation/methods/parse_datetime.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/announcements/announcements_cubit.dart';
import '../../data/models/announcement_model.dart';
import '../methods/custom_flushbar.dart';

class AnnouncementHistoryScreen extends StatefulWidget {
  const AnnouncementHistoryScreen({super.key});

  @override
  State<AnnouncementHistoryScreen> createState() =>
      _AnnouncementHistoryScreenState();
}

class _AnnouncementHistoryScreenState extends State<AnnouncementHistoryScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<AnnouncementsCubit>(context).loadAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    var heightOfNotification = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          'Announcements',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
              fontFamily: 'Axis'),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
        builder: (context, state) {
          if (state is AnnouncementsSuccess) {
            var groupedList = groupBy(state.announcementsList,
                    (Announcement announcement) => parseDate(announcement.date))
                .entries
                .toList();
            groupedList.sort((a, b) => b.key.compareTo(a.key));

            return ListView.builder(
                itemCount: groupedList.length,
                itemBuilder: (context, position) {
                  var groupedData = groupedList[position];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 5,
                                height: ((heightOfNotification + 5) *
                                        groupedData.value.length) +
                                    36,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: position == 0
                                      ? Colors.deepOrangeAccent
                                      : Colors.blue,
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 8, 0, 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 10),
                                        child: Text(
                                          groupedData.key,
                                          style: TextStyle(
                                              color: position == 0
                                                  ? Colors.deepOrangeAccent
                                                  : Colors.blue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            primary: false,
                                            shrinkWrap: true,
                                            itemCount: groupedList[position]
                                                .value
                                                .length,
                                            itemBuilder: (context, itemIndex) {
                                              groupedList[position].value.sort(
                                                  (a, b) =>
                                                      b.date.compareTo(a.date));
                                              return GestureDetector(
                                                onTap: () {
                                                  showAnnouncememt(
                                                      groupedList[position]
                                                          .value[itemIndex]);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    5)),
                                                        color: AppColors
                                                            .cardBgColor,
                                                        shape:
                                                            BoxShape.rectangle),
                                                    height:
                                                        heightOfNotification,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                              groupedList[
                                                                      position]
                                                                  .value[
                                                                      itemIndex]
                                                                  .heading
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      20.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      GoogleFonts
                                                                          .sora
                                                                          .toString())),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0),
                                                            child: Text(
                                                                groupedList[position]
                                                                    .value[
                                                                        itemIndex]
                                                                    .desc
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontFamily:
                                                                        GoogleFonts
                                                                            .sora
                                                                            .toString())),
                                                          ),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return Center(
                child: Text("Loading Announcement History ...",
                    style: TextStyle(color: AppColors.secondaryColor)));
          }
        },
      ),
    );
  }

  showAnnouncememt(Announcement announcement) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.cardBgColor,
            title: Text(
              announcement.heading,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            content: Text(
              announcement.desc,
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              announcement.url != null && announcement.url != ""
                  ? TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _launchURL(announcement.url, context);
                      },
                      child: const Text(
                        "Open link",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  : Container(),
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

void _launchURL(url, BuildContext context) async {
  final Uri uri = Uri.parse(url);
  try {
    await canLaunchUrl(uri)
        ? await launchUrl(uri)
        : throw 'Could not launch $uri';
  } catch (e) {
    showCustomFlushbar("Can't Open Link",
        "The link may be null or may have some issues.", context);
  }
}
