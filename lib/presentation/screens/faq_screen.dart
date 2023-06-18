import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riviera23/cubit/info/sponsors/sponsors_cubit.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/info/faq/faq_cubit.dart';
import '../../utils/app_theme.dart';
import '../methods/custom_flushbar.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

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
        BlocProvider(create: (context) => SponsorsCubit())
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
                Text("Sponsors", style: AppTheme.appTheme.textTheme.titleLarge),
                BlocBuilder<SponsorsCubit, SponsorsState>(
                  builder: (context, state) {
                    if (state is SponsorsSuccess) {
                      var priorList = state.sponsorsList
                          .where((element) => element.prior == true)
                          .toList();
                      priorList.sort((a, b) => a.id.compareTo(b.id));
                      if (priorList.isEmpty) {
                        return Container();
                      }
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: priorList.length,
                          itemBuilder: (context, position) {
                            var sponsor = priorList[position];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Card(
                                color: AppColors.cardBgColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: CachedNetworkImage(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        imageUrl: sponsor.url.toString(),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 250.0,
                                          width: 200.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fitWidth),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: AppColors.primaryColor,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                "assets/placeholder.png"),
                                      )),
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
                BlocBuilder<SponsorsCubit, SponsorsState>(
                  builder: (context, state) {
                    if (state is SponsorsSuccess) {
                      var regularList = state.sponsorsList
                          .where((element) => element.prior == false)
                          .toList();
                      regularList.sort((a, b) => a.id.compareTo(b.id));

                      if (regularList.isEmpty) {
                        return Container();
                      }
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.cardBgColor),
                          child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemCount: regularList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.width * 0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: CachedNetworkImage(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      imageUrl:
                                          regularList[index].url.toString(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 250.0,
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: AppColors.primaryColor,
                                        highlightColor: Colors.grey,
                                        child: Container(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset("assets/app_icon.png"),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      );
                    } else {
                      return const SizedBox(height: 0);
                    }
                  },
                ),
                /*InkWell(
                  onTap: () {
                    _launchURL("https://riviera.vit.ac.in/#sponsors", context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Center(
                      child: Text("See more",
                          style: TextStyle(color: AppColors.highlightColor)),
                    ),
                  ),
                ),*/
                const SizedBox(
                  height: 20,
                ),
                Text("FAQ", style: AppTheme.appTheme.textTheme.titleLarge),
                BlocBuilder<FaqCubit, FaqState>(
                  builder: (context, state) {
                    if (state is FaqSuccess) {
                      state.faqList.sort((a, b) => a.id.compareTo(b.id));
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
                                    collapsedIconColor:
                                        AppColors.secondaryColor,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
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

                    return Center(
                      child: Text("Loading FAQs...",
                          style: TextStyle(color: AppColors.secondaryColor)),
                    );
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
