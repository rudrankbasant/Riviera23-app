import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/presentation/methods/custom_flushbar.dart';
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(45, 45, 45, 10),
            child: Image.asset("assets/riviera_icon.png"),
          ),
          Container(
            width: double.infinity,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '#riviera23',
                style: GoogleFonts.sora(
                    color: AppColors.highlightColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 23),
                children: <TextSpan>[
                  TextSpan(
                      text: ' photowall',
                      style: GoogleFonts.sora(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 23)),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Container(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Use ',
                  style: GoogleFonts.sora(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(
                        text: '#riviera23',
                        style: GoogleFonts.sora(
                            color: AppColors.highlightColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    TextSpan(
                        text:
                            ' on your Instagram to get featured on this timeline.',
                        style: GoogleFonts.sora(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          BlocBuilder<HashtagCubit, HashtagState>(
            builder: (context, state) {
              if (state is HashtagSuccess) {
                if (state.hashtags.isNotEmpty) {
                  return ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                              likeCount: state.hashtags[itemIndex].likeCount,
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: SpinKitThreeBounce(
                    color: AppColors.secondaryColor,
                    size: 30,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _launchURL(_url) async {
    final Uri _uri = Uri.parse(_url);
    try {
      // await canLaunchUrl(_uri)
      //     ? await launchUrl(_url)
      //     : throw 'Could not launch $_uri';
      await canLaunchUrl(_uri);
      await launchUrl(_uri);
    } catch (e) {
      print(e.toString());
      showCustomFlushbar("Can't Open Link",
          "The link may be null or may have some issues.", context);
    }
  }
}
