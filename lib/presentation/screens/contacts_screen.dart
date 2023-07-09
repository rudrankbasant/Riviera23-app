import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/data/models/team_member_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../cubit/info/contacts/contacts_cubit.dart';
import '../../cubit/info/team/team_cubit.dart';
import '../../data/models/contact_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants/strings/asset_paths.dart';
import '../../utils/constants/strings/strings.dart';
import '../methods/launch_url.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

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
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.meetTheTeam,
                    style: AppTheme.appTheme.textTheme.titleLarge),
                buildTeamList(),
                buildMoreTeamInfo(context),
                const SizedBox(
                  height: 16,
                ),
                Text(Strings.contactUs,
                    style: AppTheme.appTheme.textTheme.titleLarge),
                buildContactList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocBuilder<ContactsCubit, ContactsState> buildContactList() {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        if (state is ContactsSuccess) {
          state.contactsList.sort((a, b) => a.id.compareTo(b.id));
          List<Contact> sortedContactList = state.contactsList;
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sortedContactList.length,
              itemBuilder: (context, position) {
                Contact contact = sortedContactList[position];
                return buildContactCard(contact);
              });
        }

        return Text(
          Strings.loadingContacts,
          style: TextStyle(color: AppColors.secondaryColor),
        );
      },
    );
  }

  Padding buildContactCard(Contact contact) {
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
                    fontFamily: GoogleFonts.sora.toString())),
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
  }

  InkWell buildMoreTeamInfo(BuildContext context) {
    return InkWell(
      onTap: () {
        launchURL(Strings.teamLink, context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: Center(
          child: Text(Strings.seeMore,
              style: TextStyle(color: AppColors.highlightColor)),
        ),
      ),
    );
  }

  BlocBuilder<TeamCubit, TeamState> buildTeamList() {
    return BlocBuilder<TeamCubit, TeamState>(
      builder: (context, state) {
        if (state is TeamSuccess) {
          state.teamList.sort((a, b) => a.id.compareTo(b.id));
          List<TeamMember> sortedTeamList = state.teamList;
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sortedTeamList.length,
              itemBuilder: (context, position) {
                TeamMember teamMember = sortedTeamList[position];
                return buildTeamMemberCard(context, teamMember);
              });
        }
        return Text(
          Strings.loadingTeam,
          style: TextStyle(color: AppColors.secondaryColor),
        );
      },
    );
  }

  Padding buildTeamMemberCard(BuildContext context, TeamMember teamMember) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Card(
        color: AppColors.cardBgColor,
        child: Row(
          children: [
            buildMemberImage(context, teamMember),
            buildMemberData(teamMember)
          ],
        ),
      ),
    );
  }

  Expanded buildMemberData(TeamMember teamMember) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(teamMember.name.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.sora.toString())),
          Text(teamMember.designation,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
              )),
        ],
      ),
    );
  }

  Padding buildMemberImage(BuildContext context, TeamMember teamMember) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.height * 0.15,
          child: CachedNetworkImage(
            height: 250,
            width: 200,
            imageUrl: teamMember.url.toString(),
            imageBuilder: (context, imageProvider) => Container(
              height: 250.0,
              width: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
            fit: BoxFit.cover,
          )),
    );
  }
}
