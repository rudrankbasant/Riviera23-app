import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cubit/Hashtag/Hashtag_state.dart';
import '../../cubit/hashtag/hashtag_cubit.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants/strings/asset_paths.dart';
import '../../utils/constants/strings/strings.dart';
import '../methods/launch_url.dart';
import '../widgets/hashtag_card.dart';

class HashtagsScreen extends StatefulWidget {
  const HashtagsScreen({super.key});

  @override
  State<HashtagsScreen> createState() => _HashtagsScreenState();
}

class _HashtagsScreenState extends State<HashtagsScreen> {
  List<Color> colorsList = [
    const Color(0xff466FFF),
    const Color(0xff4C3CB6),
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
          buildEventIcon(),
          buildPageDesc(),
          const SizedBox(
            height: 5,
          ),
          buildPageHashtag(),
          const SizedBox(
            height: 30,
          ),
          buildHashtagPosts(),
        ],
      ),
    );
  }

  Padding buildPageHashtag() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: Strings.desc1,
          style: GoogleFonts.sora(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
          children: <TextSpan>[
            TextSpan(
                text: Strings.rivieraHashtag,
                style: GoogleFonts.sora(
                    color: AppColors.highlightColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
            TextSpan(
                text: Strings.desc2,
                style: GoogleFonts.sora(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }

  SizedBox buildPageDesc() {
    return SizedBox(
      width: double.infinity,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: Strings.rivieraHashtag,
          style: GoogleFonts.sora(
              color: AppColors.highlightColor,
              fontWeight: FontWeight.w500,
              fontSize: 23),
          children: <TextSpan>[
            TextSpan(
                text: Strings.photowall,
                style: GoogleFonts.sora(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 23)),
          ],
        ),
      ),
    );
  }

  Padding buildEventIcon() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(45, 45, 45, 10),
      child: Image.asset(AssetPaths.rivieraIcon),
    );
  }

  BlocBuilder<HashtagCubit, HashtagState> buildHashtagPosts() {
    return BlocBuilder<HashtagCubit, HashtagState>(
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
                      launchURL(
                          state.hashtags[itemIndex].permalink, context, true);
                    },
                    child: Center(
                      child: HashtagCard(
                        index: itemIndex,
                        caption: state.hashtags[itemIndex].caption,
                        imgUrl: state.hashtags[itemIndex].mediaUrl,
                        color: colorsList[itemIndex % 2],
                        likeCount: state.hashtags[itemIndex].likeCount,
                        commentCount: state.hashtags[itemIndex].commentsCount,
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 300,
                  ),
                  SpinKitThreeBounce(
                    color: AppColors.secondaryColor,
                    size: 30,
                  ),
                ],
              ),
            );
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
    );
  }
}
