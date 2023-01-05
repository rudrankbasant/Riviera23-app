import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/Hashtag/Hashtag_state.dart';
import '../../cubit/hashtag/hashtag_cubit.dart';
import '../../utils/app_colors.dart';
import '../widgets/hashtag_card.dart';

class HashtagsScreen extends StatefulWidget {
  @override
  State<HashtagsScreen> createState() => _HashtagsScreenState();
}

class _HashtagsScreenState extends State<HashtagsScreen> {
  List<Color> colorsList = [
    Color(0xff466FFF),
    Color(0xff4C3CB6),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<HashtagCubit>();
      cubit.getAllHashtag();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/riviera_icon.png"),
            Container(
              width: double.infinity,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '#riviera23',
                  style: TextStyle(
                    color: AppColors.highlightColor,
                    fontSize: 23,
                    fontFamily: GoogleFonts.sora.toString(),
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' photowall',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 23,
                          fontFamily: GoogleFonts.sora.toString(),
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Use ',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 15,
                    fontFamily: GoogleFonts.sora.toString(),
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '#riviera23',
                        style: TextStyle(
                          color: AppColors.highlightColor,
                          fontSize: 15,
                          fontFamily: GoogleFonts.sora.toString(),
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                        text:
                            ' on your instagram to get featured on this timeline.',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 15,
                          fontFamily: GoogleFonts.sora.toString(),
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<HashtagCubit, HashtagState>(
                builder: (context, state) {
                  if (state is HashtagSuccess) {
                    if (state.hashtags.isNotEmpty) {
                      return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.hashtags.length,
                          itemBuilder: (context, itemIndex) {
                            return GestureDetector(
                              onTap: () {
                                _launchURL(state.hashtags[itemIndex].permalink);
                              },
                              child: Center(
                                child: HashtagCard(
                                  index: itemIndex,
                                  caption: state.hashtags[itemIndex].caption,
                                  imgUrl: state.hashtags[itemIndex].mediaUrl,
                                  color: colorsList[itemIndex % 2],
                                  likeCount:
                                      state.hashtags[itemIndex].likeCount,
                                  commentCount:
                                      state.hashtags[itemIndex].commentsCount,
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Text("No posts yet");
                    }
                  }
                  if (state is HashtagError) {
                    return Text(state.error);
                  }
                  return Center(
                    child: SpinKitThreeBounce(
                      color: AppColors.secondaryColor,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(_url) async {
    try {
      await canLaunchUrl(_url);
      await launchUrl(_url);
    } catch (e) {}
  }
}
