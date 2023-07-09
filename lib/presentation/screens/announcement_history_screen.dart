import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/presentation/methods/parse_datetime.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../cubit/announcements/announcements_cubit.dart';
import '../../data/models/announcement_model.dart';
import '../../utils/constants/strings/strings.dart';
import '../methods/launch_url.dart';

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
    double heightOfNotification = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: buildBody(heightOfNotification),
    );
  }

  BlocBuilder<AnnouncementsCubit, AnnouncementsState> buildBody(
      double heightOfNotification) {
    return BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
      builder: (context, state) {
        if (state is AnnouncementsSuccess) {
          List<MapEntry<String, List<Announcement>>> groupedList =
              getGroupedList(state.announcementsList);
          return ListView.builder(
              itemCount: groupedList.length,
              itemBuilder: (context, position) {
                MapEntry<String, List<Announcement>> groupedData =
                    groupedList[position];
                return buildAnnouncementCard(
                    heightOfNotification, groupedData, position, groupedList);
              });
        } else {
          return Center(
              child: Text(Strings.loadingAnnouncement,
                  style: TextStyle(color: AppColors.secondaryColor)));
        }
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      title: const Text(
        Strings.announcements,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            fontFamily: 'Axis'),
      ),
      centerTitle: true,
    );
  }

  Column buildAnnouncementCard(
      double heightOfNotification,
      MapEntry<String, List<Announcement>> groupedData,
      int position,
      List<MapEntry<String, List<Announcement>>> groupedList) {
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
                buildLeftBar(heightOfNotification, groupedData, position),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 0, 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildCardHeading(groupedData, position),
                        buildCardData(
                            groupedList, position, heightOfNotification)
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
  }

  Flexible buildCardData(List<MapEntry<String, List<Announcement>>> groupedList,
      int position, double heightOfNotification) {
    return Flexible(
      fit: FlexFit.loose,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          itemCount: groupedList[position].value.length,
          itemBuilder: (context, itemIndex) {
            groupedList[position]
                .value
                .sort((a, b) => b.date.compareTo(a.date));
            return buildAnnouncementData(
                groupedList, position, itemIndex, heightOfNotification);
          }),
    );
  }

  Padding buildCardHeading(
      MapEntry<String, List<Announcement>> groupedData, int position) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Text(
        groupedData.key,
        style: TextStyle(
            color: position == 0 ? Colors.deepOrangeAccent : Colors.blue,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  GestureDetector buildAnnouncementData(
      List<MapEntry<String, List<Announcement>>> groupedList,
      int position,
      int itemIndex,
      double heightOfNotification) {
    return GestureDetector(
      onTap: () {
        showAnnouncement(groupedList[position].value[itemIndex]);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: AppColors.cardBgColor,
              shape: BoxShape.rectangle),
          height: heightOfNotification,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(groupedList[position].value[itemIndex].heading.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.sora.toString())),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                      groupedList[position].value[itemIndex].desc.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          fontFamily: GoogleFonts.sora.toString())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildLeftBar(double heightOfNotification,
      MapEntry<String, List<Announcement>> groupedData, int position) {
    return Container(
      width: 5,
      height: ((heightOfNotification + 5) * groupedData.value.length) + 36,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: position == 0 ? Colors.deepOrangeAccent : Colors.blue,
        shape: BoxShape.rectangle,
      ),
    );
  }

  List<MapEntry<String, List<Announcement>>> getGroupedList(
      List<Announcement> announcementsList) {
    List<MapEntry<String, List<Announcement>>> groupedList = groupBy(
            announcementsList,
            (Announcement announcement) => parseDate(announcement.date))
        .entries
        .toList();
    groupedList.sort((a, b) => b.key.compareTo(a.key));
    return groupedList;
  }

  showAnnouncement(Announcement announcement) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildAnnouncementDialog(announcement, context);
        });
  }

  AlertDialog buildAnnouncementDialog(
      Announcement announcement, BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBgColor,
      title: Text(
        announcement.heading,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      content: Text(
        announcement.desc,
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        announcement.url != null && announcement.url != ""
            ? buildLinkButton(context, announcement)
            : Container(),
        buildCloseButton(context),
      ],
    );
  }

  TextButton buildCloseButton(BuildContext context) {
    return TextButton(
      child: const Text(
        Strings.close,
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  TextButton buildLinkButton(BuildContext context, Announcement announcement) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        launchURL(announcement.url, context);
      },
      child: const Text(
        Strings.openLink,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
