import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../cubit/announcements/announcements_cubit.dart';

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
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.announcementsList.length,
                itemBuilder: (context, position) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBgColor,
                    ),
                    child: ExpansionTile(
                        backgroundColor: AppColors.cardBgColor,
                        title: Text(
                          "Q. ${state.announcementsList[position].heading}",
                          style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                            ),
                            child: Text(
                              state.announcementsList[position].desc,
                              style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          )
                        ]),
                  );
                });
          }

          return Center(
              child: Text("Loading Announcement History ...",
                  style: TextStyle(color: AppColors.secondaryColor)));
        },
      ),
    );
  }
}
