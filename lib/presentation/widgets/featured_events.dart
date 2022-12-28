import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/utils/app_colors.dart';

class FeaturedEvents extends StatefulWidget {
  List<String> imgList;

  FeaturedEvents({required this.imgList});

  @override
  _FeaturedEventsState createState() => _FeaturedEventsState();
}

class _FeaturedEventsState extends State<FeaturedEvents> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final List<Widget> imageSliders = widget.imgList
        .map((item) => Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: AppColors.primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 250,
                      width: 200,
                      child: Image.network(
                        item,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "DJ Snake",
                      style: TextStyle(
                          fontFamily: GoogleFonts.sora.toString(),
                          color: AppColors.highlightColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Wed 23 Feb",
                      style: TextStyle(
                          fontFamily: GoogleFonts.sora.toString(),
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Outdoor Stadium",
                      style: TextStyle(
                          fontFamily: GoogleFonts.sora.toString(),
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ))
        .toList();

    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              enlargeCenterPage: false,
              aspectRatio: 1 / 1,
              viewportFraction: 0.5,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ],
    );
  }
}
