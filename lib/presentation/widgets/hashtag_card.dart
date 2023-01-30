import 'package:flutter/material.dart';

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
    return Row(
      children: [
        Expanded(
          child: RotationTransition(
            turns: (index != null)
                ? (index! % 2 == 0
                    ? AlwaysStoppedAnimation(12 / 360)
                    : AlwaysStoppedAnimation(-12 / 360))
                : AlwaysStoppedAnimation(0),
            child: Container(
              margin: EdgeInsets.all(40),
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
                      Container(
                        child: Image.network(
                          widget.imgUrl != null
                              ? widget.imgUrl.toString()
                              : "https://i.ytimg.com/vi/v2gseMj1UGI/maxresdefault.jpg",
                          // width: 300,
                          // height: 300,
                          fit: BoxFit.contain,
                        ),
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
                  // ExpandableText(
                  //   caption,
                  //   expandText: "more",
                  //   collapseText: "see less",
                  //   maxLines: 4,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
