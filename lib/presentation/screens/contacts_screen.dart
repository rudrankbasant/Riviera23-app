import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/info/contacts/contacts_cubit.dart';
import '../../cubit/info/team/team_cubit.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';
import '../methods/custom_flushbar.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TeamCubit()),
        BlocProvider(
          create: (context) => ContactsCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("MEET THE TEAM",
                    style: AppTheme.appTheme.textTheme.headline6),
                BlocBuilder<TeamCubit, TeamState>(
                  builder: (context, state) {
                    if (state is TeamSuccess) {
                      state.teamList.sort((a, b) => a.id.compareTo(b.id));
                      var sortedTeamList = state.teamList;
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sortedTeamList.length,
                          itemBuilder: (context, position) {
                            var teamMember = sortedTeamList[position];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Card(
                                color: AppColors.cardBgColor,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          child: CachedNetworkImage(
                                            height: 250,
                                            width: 200,
                                            imageUrl: teamMember.url.toString(),
                                            imageBuilder: (context, imageProvider) => Container(
                                              height: 250.0,
                                              width: 200.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: imageProvider, fit: BoxFit.cover),
                                              ),
                                            ),
                                            placeholder: (context, url) => SpinKitFadingCircle(
                                              color: AppColors.secondaryColor,
                                              size: 50.0,
                                            ),
                                            errorWidget: (context, url, error) => Image.asset(
                                                "assets/placeholder.png"),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(teamMember.name.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: GoogleFonts.sora
                                                      .toString())),
                                          Text(teamMember.designation,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.normal,
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    }

                    return Text(
                      "Loading Team",
                      style: TextStyle(color: AppColors.secondaryColor),
                    );
                  },
                ),
                InkWell(
                  onTap: () {
                    _launchURL("https://riviera.vit.ac.in/team", context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Center(
                      child: Text("See more",
                          style: TextStyle(color: AppColors.highlightColor)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text("CONTACT US",
                    style: AppTheme.appTheme.textTheme.headline6),
                BlocBuilder<ContactsCubit, ContactsState>(
                  builder: (context, state) {
                    if (state is ContactsSuccess) {
                      state.contactsList.sort((a, b) => a.id.compareTo(b.id));
                      var sortedContactList = state.contactsList;
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sortedContactList.length,
                          itemBuilder: (context, position) {
                            var contact = sortedContactList[position];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Card(
                                color: AppColors.primaryColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(contact.name.toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                GoogleFonts.sora.toString())),
                                    Text(contact.designation,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                        )),
                                    Text(contact.email,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                        )),
                                  ],
                                ),
                              ),
                            );
                          });
                    }

                    return Text(
                      "Loading Contacts",
                      style: TextStyle(color: AppColors.secondaryColor),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _launchURL(_url, BuildContext context) async {
  final Uri _uri = Uri.parse(_url);
  try {
    await canLaunchUrl(_uri)
        ? await launchUrl(_uri)
        : throw 'Could not launch $_uri';
  } catch (e) {
    print(e.toString());
    showCustomFlushbar("Can't Open Link",
        "The link may be null or may have some issues.", context);
  }
}
