import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HashtagCard extends StatefulWidget {
  final String caption;
  final String imgUrl;
  final Color color;
  final int? likeCount;
  final int? commentCount;

  const HashtagCard(
      {Key? key,
      required this.caption,
      required this.imgUrl,
      required this.color,
      required this.likeCount,
      required this.commentCount})
      : super(key: key);

  @override
  State<HashtagCard> createState() => _HashtagCardState(
      caption: caption,
      imgUrl: imgUrl,
      color: color,
      likeCount: likeCount,
      commentCount: commentCount);
}

class _HashtagCardState extends State<HashtagCard> {
  final String caption;
  final String imgUrl;
  final Color color;
  final int? likeCount;
  final int? commentCount;

  _HashtagCardState(
      {required this.caption,
      required this.imgUrl,
      required this.color,
      required this.likeCount,
      required this.commentCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
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
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.network(
                        widget.imgUrl,
                        // width: 300,
                        // height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text("${likeCount ?? ""}")
                          ],
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Row(
                          children: [
                            Icon(Icons.comment),
                            SizedBox(
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
      ],
    );
  }
}
