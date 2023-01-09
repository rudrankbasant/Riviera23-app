import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/cubit/info/sponsors/sponsors_cubit.dart';
import 'package:riviera23/utils/app_colors.dart';

import '../../cubit/info/faq/faq_cubit.dart';
import '../../utils/app_theme.dart';

class FAQScreen extends StatefulWidget {
  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FaqCubit(),
        ),
        BlocProvider(
            create: (context) => SponsorsCubit() )
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
                Text("Sponsors",
                    style: AppTheme.appTheme.textTheme.headline6),
                BlocBuilder<SponsorsCubit, SponsorsState>(
                  builder: (context, state) {
                    if (state is SponsorsSuccess) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.sponsorsList.length,
                          itemBuilder: (context, position) {
                            var sponsor = state.sponsorsList[position];
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
                                            sponsor.url.toString(),
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
                                        Text(sponsor.name.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: GoogleFonts.sora
                                                    .toString())),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    }

                    return Center(
                      child: Text(
                        "Sponsors Will appear here",
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("FAQ",
                    style: AppTheme.appTheme.textTheme.headline6),
                BlocBuilder<FaqCubit, FaqState>(
                  builder: (context, state) {
                    if (state is FaqSuccess) {
                      state.faqList.sort((a,b) => a.id.compareTo(b.id));
                      var sortedFaqList = state.faqList;
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sortedFaqList.length,
                          itemBuilder: (context, position) {
                            var faqQuestion = sortedFaqList[position];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.cardBgColor,
                                ),
                                child: ExpansionTile(
                                    collapsedIconColor: AppColors.secondaryColor,
                                    iconColor: AppColors.secondaryColor,
                                    backgroundColor: AppColors.cardBgColor,
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: AppColors.secondaryColor,
                                          size: 10,
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Flexible(
                                          child: Text(
                                            faqQuestion.question,
                                            style: TextStyle(
                                                color: AppColors.secondaryColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        decoration: BoxDecoration(
                                          color: AppColors.cardBgColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 0),
                                          child: Text(
                                            faqQuestion.answer,
                                            style: TextStyle(
                                                color: AppColors.secondaryColor,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      )
                                    ]),
                              ),
                            );
                          });
                    }

                    return Text("Loading FAQ",
                        style: TextStyle(color: AppColors.secondaryColor));
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
