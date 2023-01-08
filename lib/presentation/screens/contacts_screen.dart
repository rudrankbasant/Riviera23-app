import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cubit/info/contacts/contacts_cubit.dart';
import '../../cubit/info/team/team_cubit.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';

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
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.teamList.length,
                          itemBuilder: (context, position) {
                            var teamMember = state.teamList[position];
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
                                          child: Image.network(
                                            teamMember.url.toString(),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    Column(
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
                SizedBox(
                  height: 16,
                ),
                Text("CONTACT US",
                    style: AppTheme.appTheme.textTheme.headline6),
                BlocBuilder<ContactsCubit, ContactsState>(
                  builder: (context, state) {
                    if (state is ContactsSuccess) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.contactsList.length,
                          itemBuilder: (context, position) {
                            var contact = state.contactsList[position];
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
