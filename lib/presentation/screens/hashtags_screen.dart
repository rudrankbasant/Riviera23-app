import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/data/models/hashtag_model.dart';

import '../../cubit/Hashtag/Hashtag_state.dart';
import '../../cubit/hashtag/hashtag_cubit.dart';
import '../../utils/app_colors.dart';

class HashtagsScreen extends StatefulWidget {
  @override
  State<HashtagsScreen> createState() => _HashtagsScreenState();
}

class _HashtagsScreenState extends State<HashtagsScreen> {


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
      body: Column(
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
                    fontFamily: GoogleFonts.sora.toString()),
                children: <TextSpan>[
                  TextSpan(
                      text: ' photowall',
                      style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontFamily: GoogleFonts.sora.toString())),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Use ',
                style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontFamily: GoogleFonts.sora.toString()),
                children: <TextSpan>[
                  TextSpan(
                      text: '#riviera23',
                      style: TextStyle(
                          color: AppColors.highlightColor,
                          fontFamily: GoogleFonts.sora.toString())),
                  TextSpan(
                      text:
                          ' on your instagram to get featured on this timeline.',
                      style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontFamily: GoogleFonts.sora.toString())),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<HashtagCubit, HashtagState>(builder: (context, state) {
              if (state is HashtagSuccess) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.hashtags.length,
                  itemBuilder: (context, index) {
                    HashtagModel hashtagPost = state.hashtags[index];
                    return Card(
                      child: Row(
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.height * 0.1,
                              child: Image.network(
                                hashtagPost.mediaUrl.toString(),
                                fit: BoxFit.cover,
                              )),
                          Column(
                            children: [
                              Text(hashtagPost.caption.toString()),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              } else if (state is HashtagError) {
                return const Center(
                  child: Text("Error! Couldn't load."),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          )
        ],
      ),
    );
  }
}
