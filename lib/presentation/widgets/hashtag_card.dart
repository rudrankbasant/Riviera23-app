import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/app_colors.dart';

class HashtagCard extends StatefulWidget {
  final int index;
  final String? caption;
  final String? imgUrl;
  final Color? color;
  final int? likeCount;
  final int? commentCount;

  const HashtagCard(
      {Key? key,
      required this.index,
      required this.caption,
      required this.imgUrl,
      required this.color,
      required this.likeCount,
      required this.commentCount})
      : super(key: key);

  @override
  State<HashtagCard> createState() => _HashtagCardState(
      index: index,
      caption: caption,
      imgUrl: imgUrl,
      color: color,
      likeCount: likeCount,
      commentCount: commentCount);
}

class _HashtagCardState extends State<HashtagCard> {
  final int? index;
  final String? caption;
  final String? imgUrl;
  final Color? color;
  final int? likeCount;
  final int? commentCount;

  _HashtagCardState(
      {required this.index,
      required this.caption,
      required this.imgUrl,
      required this.color,
      required this.likeCount,
      required this.commentCount});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Expanded(
          child: RotationTransition(
            turns: (index != null)
                ? (index! % 2 == 0
                    ? const AlwaysStoppedAnimation(12 / 360)
                    : const AlwaysStoppedAnimation(-12 / 360))
                : const AlwaysStoppedAnimation(0),
            child: Container(
              margin: const EdgeInsets.all(40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40A3A3A3),
                    blurRadius: 4, // soften the shadow
                    spreadRadius: 0,
                    //extend the shadow
                    offset: Offset(
                      0, // Move to right 10  horizontally
                      4, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Column(
                    children: [
                      CachedNetworkImage(
                        height: height * 0.3,
                        imageUrl: imgUrl.toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
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
                            Image.asset("assets/app_icon.png"),
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite_outlined),
                              const SizedBox(
                                width: 8,
                              ),
                              Text("${likeCount ?? ""}")
                            ],
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.comment),
                              const SizedBox(
                                width: 8,
                              ),
                              Text("${commentCount ?? ""}")
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
